
# INSTRUCTIONS

## Configuration

Create a file *credentials.env* with the following variables:


AWS_ACCESS_KEY_ID=

AWS_SECRET_ACCESS_KEY=

AWS_REGION=

AWS_DEFAULT_REGION=

DATADOG_API_KEY=

DATADOG_APP_KEY=

GITHUB_TOKEN=

GITHUB_USER=

## Run


Please run with the following command


```
make

```

or 

```
make run

```

then open the concourse web UI *localhost:8080* and enter:

```
user: test
password: test
```

## Output

The output is a apache web server running in a kubernetes, created using a custom hardend AMI and with a monitor alert in datadog created using terraform.

## Process

The process is completely automatic, just create the credentials.env file as stated above.



The process has 5 main steps:

1. Concourse download and configuration using make
2. AMI Creation using Packer
3. Terraform insfractuture creation using the AMI created in the step 2
4. FluxCD configuration using the github repo.

## Architectural diagram

![Diagrama](https://i.imgur.com/uYVGqnr.png)
