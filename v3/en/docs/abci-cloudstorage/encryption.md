
# Data Encryption

## Outline of Encryption

There are two typical encryptions for cloud storages. The one is Server-Side Encryption (SSE) and another one is Client-Side Encryption (CSE). The ABCI Cloud Storage doesn't support SSE, but CSE can be used.
CSE encrypts and decrypts data by the user, and stores the encrypted data in cloud storage.

However, ABCI doesn't offer Key Management Service (KMS), so CSE using encryption keys registered to KMS cannot be used.
For instructions on performing CSE using your own generated private and public keys with [the AWS Encryption SDK](https://docs.aws.amazon.com/encryption-sdk/latest/developer-guide/introduction.html), see [CSE with the AWS Encryption SDK](#cse-with-the-aws-encryption-sdk).

| CSE Type | Description |
| :-- | :-- |
| CSE-C | Encryption with key managed on client side by user. |
| CSE-KMS | Encryption with key registered to Key Management Service |


## CSE with the AWS Encryption SDK
This procedure shows how to perform CSE using your own private and public keys with [the AWS Encryption SDK for Python](https://github.com/aws/aws-encryption-sdk-python/).

### Create Private and Public Keys
Use the `openssl` command to generate a private key (private_key.pem) and a public key (public_key.pem).
```
[username@login1 ~]$ openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:4096
[username@login1 ~]$ openssl rsa -pubout -in private_key.pem -out public_key.pem
```

### Install the AWS Encryption SDK
Install [the AWS Encryption SDK for Python](https://github.com/aws/aws-encryption-sdk-python).
Since Python 3.11 or later is currently recommended, first load Python 3.13 and activate your virtual environment.
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
Install [the AWS Encryption SDK for Python](https://github.com/aws/aws-encryption-sdk-python) using the `pip` command.
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

### File Upload with CSE
This section describes the steps to encrypt and upload example.txt in your home directory with CSE.
Prior to this, ensure that the virtual environment created in [the previous step](#install-the-aws-encryption-sdk) is activated.
```
(venv-aws-encsdk) [username@login1 ~]$ cat example.txt
This is example for CSE!
(venv-aws-encsdk) [username@login1 ~]$
```
Prepare the upload program file (Upload_By_CSE.py) in your home directory.
This program also uses [Boto3](https://aws.amazon.com/sdk-for-python/).
The variables used in the program are set as follows.

| Variable Name | Description |
| :-- | :-- |
| private_path | Path to the private key |
| public_path | Path to the public key |
| BUCKET_NAME | Destination bucket name |
| UPLOAD_KEY | Object name after upload |
| LOCAL_FILE | File name to be uploaded |
| AWS_ACCESS_KEY_ID | Access Key |
| AWS_SECRET_ACCESS_KEY | Secret Key |

!!! note
    If [configuration for the authentication](usage.md#configuration-for-the-authentication) is complete, the Access Key and Secret Key are stored in the .aws/credentials file located in your home directory.

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
Run the created Upload_By_CSE.py program to upload the file.
```
(venv-aws-encsdk) [username@login1 ~]$ python Upload_By_CSE.py
example.txt encrypted and uploaded to s3://bucket-test/example_encrypted.txt
(venv-aws-encsdk) [username@login1 ~]$
```
This object cannot be accessed without CSE, as its contents are encrypted.
```
(venv-aws-encsdk) [username@login1 ~]$ aws --endpoint-url https://s3.v3.abci.ai s3 cp s3://bucket-test/example_encrypted.txt -
y~���9;D����ގ/�A����#�܁G�jZ�?�3����C͓�kb0��"ς�ռ����ͻ�u�cZ���C����\
                                                                                                      "��&4��!o�V���X�{!4h(��I����
L�Jg�[���T̔Ϙͦ('s��ګi�["4���$�ST&� A/�ӳ*�2D��H-L�~Њ���6'�g��7�d�aZ#@3v�(�d��5���*>���KM�����9��^&4ݱA���g%J�@�^�p����������3̂�ȧ�����~l�Pj��<���hph�ƟHg0e1�m-���Kڕ�#a޽Zn��
��ڮ��bB�W^ݩ��:^@��
                           �0  �8�����-c�aWy��������B���;E������X�[�9��
(venv-aws-encsdk) [username@login1 ~]$
```


### File Download with CSE
This section describes the steps to decrypt and download the object example_encrypted.txt stored in a cloud storage bucket with CSE.
Prior to this, ensure that the virtual environment created in [the previous step](#install-the-aws-encryption-sdk) is activated.
Prepare the download program file (Download_By_CSE.py) in your home directory. This program also uses [Boto3](https://aws.amazon.com/sdk-for-python/). The variables used in the program are set as follows.

| Variable Name | Description |
| :-- | :-- |
| private_path | Path to the private key |
| public_path | Path to the public key |
| BUCKET_NAME | Source bucket name |
| DOWNLOAD_KEY | Object name to download |
| DOWNLOAD_FILE | File name after download |
| AWS_ACCESS_KEY_ID | Access Key |
| AWS_SECRET_ACCESS_KEY | Secret Key |

!!! note
    If [configuration for the authentication](usage.md#configuration-for-the-authentication) is complete, the Access Key and Secret Key are stored in the .aws/credentials file located in your home directory.

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
Run the created Download_By_CSE.py program to download the file.
```
(venv-aws-encsdk) [username@login1 ~]$ python Download_By_CSE.py
example_encrypted.txt decrypted and saved to example_decrypted.txt
(venv-aws-encsdk) [username@login1 ~]$
(venv-aws-encsdk) [username@login1 ~]$ cat example_decrypted.txt
This is example for CSE!
(venv-aws-encsdk) [username@login1 ~]$
```