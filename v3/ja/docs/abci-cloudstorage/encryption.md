
# データの暗号化

## 暗号化機能の概要

クラウド向けのストレージにおいては、一般的に、サーバ側で暗号化する Server-Side Encryption (SSE) とクライアント側で暗号化する Client-Side Encryption (CSE) があります。ABCIクラウドストレージはSSEには対応していませんが、CSEを利用できます。CSEはデータの暗号化および復号を利用者が行い、暗号化されたデータをABCIクラウドストレージに保存します。

ただし、ABCIクラウドストレージではKey Management Service(KMS)を提供していないため、KMSに保存されている暗号キーを利用してのCSEは利用できません。
利用者自身で作成した秘密鍵、公開鍵と、[AWS Encryption SDK](https://docs.aws.amazon.com/ja_jp/encryption-sdk/latest/developer-guide/introduction.html)を利用してCSEを行う手順については、[AWS Encryption SDKによるCSE](#cse-with-the-aws-encryption-sdk)をご参照ください。

| CSEの種類 | 説明 |
| :-- | :-- |
| CSE-C | ユーザがクライアント側で管理している鍵を用いて暗号化 |
| CSE-KMS | Key Management Service に登録された鍵を用いて暗号化 |


## AWS Encryption SDKによるCSE {#cse-with-the-aws-encryption-sdk}
ここでは、利用者自身で秘密鍵、公開鍵を作成し、[Python向けAWS Encryption SDK](https://github.com/aws/aws-encryption-sdk-python/)を利用してCSEを行う手順を示します。

### 秘密鍵と公開鍵の作成
`openssl`コマンドにより、秘密鍵（private_key.pem）と公開鍵（public_key.pem）を作成します。
```
[username@login1 ~]$ openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
[username@login1 ~]$ openssl rsa -pubout -in private_key.pem -out public_key.pem
```

### AWS Encryption SDKのインストール {#install-the-aws-encryption-sdk}
[Python向けAWS Encryption SDK](https://github.com/aws/aws-encryption-sdk-python)をインストールします。現在、Python 3.11+が環境として推奨されているため、まずはPython 3.13を事前にロードし、仮想環境を有効化します。
```
[username@login1 ~]$ module load python/3.13/
[username@login1 ~]$
[username@login1 ~]$ module li
Currently Loaded Modulefiles:
 1) python/3.13/3.13.2
[username@login1 ~]$
[username@login1 ~]$ python -m venv venv-aws-encsdk
[username@login1 ~]$ 
[username@login1 ~]$ source venv-aws-encsdk/bin/activate
(venv-aws-encsdk) [username@login1 ~]$
```
`pip`コマンドにより、[Python向けAWS Encryption SDK](https://github.com/aws/aws-encryption-sdk-python)をインストールします。
```
(venv-aws-encsdk) [username@login1 ~]$ pip install "aws-encryption-sdk[MPL]" 
Collecting aws-encryption-sdk[MPL]
  Using cached aws_encryption_sdk-4.0.3-py2.py3-none-any.whl.metadata (14 kB)
Collecting boto3>=1.10.0 (from aws-encryption-sdk[MPL])
  Downloading boto3-1.40.46-py3-none-any.whl.metadata (6.7 kB)
Collecting cryptography>=3.4.6 (from aws-encryption-sdk[MPL])
.....
Successfully installed DafnyRuntimePython-4.9.0 attrs-25.4.0 aws-cryptographic-material-providers-1.11.1 aws-cryptography-internal-dynamodb-1.11.1 aws-cryptography-internal-kms-1.11.1 aws-cryptography-internal-primitives-1.11.1 aws-cryptography-internal-standard-library-1.11.1 aws-encryption-sdk-4.0.3 boto3-1.40.46 botocore-1.40.46 cffi-2.0.0 cryptography-45.0.7 jmespath-1.0.1 pycparser-2.23 python-dateutil-2.9.0.post0 pytz-2025.2 s3transfer-0.14.0 six-1.17.0 urllib3-2.5.0 wrapt-1.17.3
[notice] A new release of pip is available: 24.3.1 -> 25.2
[notice] To update, run: pip install --upgrade pip
(venv-aws-encsdk) [username@login1 ~]$
```

### CSEを用いたファイルのアップロード
ここでは、ホームディレクトリに存在するexample.txtをCSEで暗号化してアップロードを行う際の手順を示します。また、[前手順](#install-the-aws-encryption-sdk)で作成した仮想環境を事前に有効化しておきます。
```
(venv-aws-encsdk) [username@login1 ~]$ cat example.txt
This is example for CSE!
(venv-aws-encsdk) [username@login1 ~]$
```
アップロード用のプログラムファイル(Upload_By_CSE.py)をホームディレクトリに用意します。このプログラムではAWSのPython SDKである、[Boto3](https://aws.amazon.com/jp/sdk-for-python/)も利用しています。
プログラム内の各変数については以下の通り設定します。

| 変数名 | 説明 |
| :-- | :-- |
| private_path | 秘密鍵のパス |
| public_path | 公開鍵のパス |
| BUCKET_NAME | アップロード先となるバケット名 |
| UPLOAD_KEY | アップロード後のオブジェクト名 |
| LOCAL_FILE | アップロード対象となるファイル名 |
| AWS_ACCESS_KEY_ID | Access Key |
| AWS_SECRET_ACCESS_KEY | Secret Key |

!!! note
    [認証の設定](usage.md#configuration-for-the-authentication)が完了している場合、Access KeyとSecret Keyについてはホームディレクトリの`.aws/credentials`に記載があります。

Upload_By_CSE.py
```python
import boto3
import aws_encryption_sdk
from aws_encryption_sdk import CommitmentPolicy
from aws_cryptographic_material_providers.mpl import AwsCryptographicMaterialProviders
from aws_cryptographic_material_providers.mpl.config import MaterialProvidersConfig
from aws_cryptographic_material_providers.mpl.models import CreateRawRsaKeyringInput, PaddingScheme
from cryptography.hazmat.primitives import serialization

def load_keys(private_path="private_key.pem", public_path="public_key.pem"):
    with open(private_path, "rb") as f:
        private_key = f.read()
    with open(public_path, "rb") as f:
        public_key = f.read()
    return public_key, private_key

def create_keyring(public_key, private_key):
    mat_prov = AwsCryptographicMaterialProviders(config=MaterialProvidersConfig())
    keyring_input = CreateRawRsaKeyringInput(
        key_namespace="MyAppKeys",
        key_name="S3RSAKey",
        padding_scheme=PaddingScheme.OAEP_SHA256_MGF1,
        public_key=public_key,
        private_key=private_key
    )
    return mat_prov.create_raw_rsa_keyring(input=keyring_input)

def upload_encrypted_file(bucket_name, key, filename, keyring, client, s3_client):
    with open(filename, "rb") as f:
        plaintext = f.read()

    ciphertext, _ = client.encrypt(
        source=plaintext,
        keyring=keyring
    )

    s3_client.put_object(Bucket=bucket_name, Key=key, Body=ciphertext)
    print(f"{filename} encrypted and uploaded to s3://{bucket_name}/{key}")

if __name__ == "__main__":
    BUCKET_NAME = "bucket-test" 
    UPLOAD_KEY = "example_encrypted.txt" 
    LOCAL_FILE = "example.txt" 
    ENDPOINT_URL = "https://s3.v3.abci.ai" 
    AWS_ACCESS_KEY_ID = "XXXXXXXXXXXXXXXXXXX" 
    AWS_SECRET_ACCESS_KEY = "XXXXXXXXXXXXXXXXX" 

    public_key, private_key = load_keys()
    keyring = create_keyring(public_key, private_key)
    client = aws_encryption_sdk.EncryptionSDKClient(
        commitment_policy=CommitmentPolicy.REQUIRE_ENCRYPT_REQUIRE_DECRYPT
    )
    s3_client = boto3.client(
        "s3",
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
        endpoint_url=ENDPOINT_URL,
        config=boto3.session.Config(signature_version="s3v4",
        request_checksum_calculation="when_required",
        response_checksum_validation="when_required" 
        )
    )

    upload_encrypted_file(BUCKET_NAME, UPLOAD_KEY, LOCAL_FILE, keyring, client, s3_client)
```
作成されたUpload_By_CSE.pyを実行し、ファイルをアップロードします。
```
(venv-aws-encsdk) [username@login1 ~]$ python Upload_By_CSE.py
example.txt encrypted and uploaded to s3://bucket-test/example_encrypted.txt
(venv-aws-encsdk) [username@login1 ~]$
```
CSEを利用せずオブジェクトにアクセスすると、暗号化により中身を確認できません。
```
(venv-aws-encsdk) [username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://bucket-test/example_encrypted.txt -
y~���9;D����ގ/�A����#�܁G�jZ�?�3����C͓�kb0��"ς�ռ����ͻ�u�cZ���C����\
                                                                                                      "��&4��!o�V���X�{!4h(��I����
L�Jg�[���T̔Ϙͦ('s��ګi�["4���$�ST&� A/�ӳ*�2D��H-L�~Њ���6'�g��7�d�aZ#@3v�(�d��5���*>���KM�����9��^&4ݱA���g%J�@�^�p����������3̂�ȧ�����~l�Pj��<���hph�ƟHg0e1�m-���Kڕ�#a޽Zn��
��ڮ��bB�W^ݩ��:^@��
                           �0  �8�����-c�aWy��������B���;E������X�[�9��
(venv-aws-encsdk) [username@login1 ~]$
```



### CSEを用いたファイルのダウンロード
ここでは、クラウドストレージのバケットに存在するexample_encrypted.txtというオブジェクトをCSEで復号化してダウンロードを行う際の手順を示します。また、[前手順](#install-the-aws-encryption-sdk)で作成した仮想環境を事前に有効化しておきます。
ダウンロード用のプログラムファイル(Download_By_CSE.py)をホームディレクトリに用意します。このプログラムではAWSのPython SDKである、[Boto3](https://aws.amazon.com/jp/sdk-for-python/)も利用しています。
プログラム内の各変数については以下の通り設定します。

| 変数名 | 説明 |
| :-- | :-- |
| private_path | 秘密鍵のパス |
| public_path | 公開鍵のパス |
| BUCKET_NAME | ダウンロード元となるバケット名 |
| DOWNLOAD_KEY | ダウンロード対象のオブジェクト名 |
| DOWNLOAD_FILE | ダウンロード後に保存されるファイル名 |
| AWS_ACCESS_KEY_ID | Access Key |
| AWS_SECRET_ACCESS_KEY | Secret Key |

!!! note
    [認証の設定](usage.md#configuration-for-the-authentication)が完了している場合、Access KeyとSecret Keyについてはホームディレクトリの`.aws/credentials`に記載があります。

Download_By_CSE.py
```python
import boto3
import aws_encryption_sdk
from aws_encryption_sdk import CommitmentPolicy
from aws_cryptographic_material_providers.mpl import AwsCryptographicMaterialProviders
from aws_cryptographic_material_providers.mpl.config import MaterialProvidersConfig
from aws_cryptographic_material_providers.mpl.models import CreateRawRsaKeyringInput, PaddingScheme
from cryptography.hazmat.primitives import serialization

def load_keys(private_path="private_key.pem", public_path="public_key.pem"):
    with open(private_path, "rb") as f:
        private_key = f.read()
    with open(public_path, "rb") as f:
        public_key = f.read()
    return public_key, private_key

def create_keyring(public_key, private_key):
    mat_prov = AwsCryptographicMaterialProviders(config=MaterialProvidersConfig())
    keyring_input = CreateRawRsaKeyringInput(
        key_namespace="MyAppKeys",
        key_name="S3RSAKey",
        padding_scheme=PaddingScheme.OAEP_SHA256_MGF1,
        public_key=public_key,
        private_key=private_key
    )
    return mat_prov.create_raw_rsa_keyring(input=keyring_input)

def download_and_decrypt_file(bucket_name, key, download_path, keyring, client, s3_client):
    response = s3_client.get_object(Bucket=bucket_name, Key=key)
    ciphertext = response["Body"].read()

    plaintext, _ = client.decrypt(
        source=ciphertext,
        keyring=keyring
    )

    with open(download_path, "wb") as f:
        f.write(plaintext)
    print(f"{key} decrypted and saved to {download_path}")

if __name__ == "__main__":
    BUCKET_NAME = "bucket-test" 
    DOWNLOAD_KEY = "example_encrypted.txt" 
    DOWNLOAD_FILE = "example_decrypted.txt" 
    ENDPOINT_URL = "https://s3.v3.abci.ai" 
    AWS_ACCESS_KEY_ID = "XXXXXXXXXXXXXXXXXXXXX" 
    AWS_SECRET_ACCESS_KEY = "XXXXXXXXXXXXXXXXXXXXXX" 

    public_key, private_key = load_keys()
    keyring = create_keyring(public_key, private_key)
    client = aws_encryption_sdk.EncryptionSDKClient(
        commitment_policy=CommitmentPolicy.REQUIRE_ENCRYPT_REQUIRE_DECRYPT
    )
    s3_client = boto3.client(
        "s3",
        aws_access_key_id=AWS_ACCESS_KEY_ID,
        aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
        endpoint_url=ENDPOINT_URL,
        config=boto3.session.Config(signature_version="s3v4",
        request_checksum_calculation="when_required",
        response_checksum_validation="when_required" 
        )
    )

    download_and_decrypt_file(BUCKET_NAME, DOWNLOAD_KEY, DOWNLOAD_FILE, keyring, client, s3_client)
```
作成されたDownload_By_CSE.pyを実行し、ファイルをダウンロードします。
```
(venv-aws-encsdk) [username@login1 ~]$ python Download_By_CSE.py
example_encrypted.txt decrypted and saved to example_decrypted.txt
(venv-aws-encsdk) [username@login1 ~]$
(venv-aws-encsdk) [username@login1 ~]$ cat example_decrypted.txt
This is example for CSE!
(venv-aws-encsdk) [username@login1 ~]$
```