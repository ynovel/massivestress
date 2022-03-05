# Massive Stress Framework
Multi-Cloud Multi-Runner Stress Test Framework.

This tool is created for purpose of convenient stress testing to measure performance and reliability of systems.

The idea is to have flexibility to choose any combination of:
* **Cloud provider**, choose what your organization already use: DO, AWS etc.
* **Runner**: alpine/bombardier, mhddos, dripper.py etc.
* **Resources** list - choose what is more convenient for your type of deployment: remote dedicated source or local file.

All parameters such as instances count, connections counts could be **configured**.

## Quick Setup & Run
[Istall Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform).
```shell
cd keys
/bin/sh gen_ssh_keys.sh
export DIGITALOCEAN_ACCESS_TOKEN="<CHANGE TO YOUR PERSONAL ACCESS TOKEN>"
cd ../terraform/digital_ocean
terraform init
echo -e 'runner_resources_url = "<CHANGE TO URL WITH RESOURCES FILE, WHICH IS TEXT WITH ONE TESTED URL PER LINE>"
runner_bombardier_connections_per_resource = 500
instance_count = 3
instance_region = "fra1"
instance_type = "s-1vcpu-1gb"
runner_bombardier_duration = "720h"
' > terraform.tfstate
terraform apply # type "yes"
```

More detailed setup instructions below:

## Install Terraform
This tool is working on cloud infrastructures, which are setup and provisioned with Terraform.

Parameters could be changed from defaults and configured via terraform.tfvars.

[Official installation instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform).

### Mac
```shell
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
### Ubuntu
```shell
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```
### Other
[Find instructions on official website](https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform).
## Provisioning keys
You also need ssh key pair for provisioning.

You can generate them or specify existing in config.

Use script to generate ssh keypair to default destination:
```shell
cd keys
/bin/sh gen_ssh_keys.sh
```
## Configuration
Feel free to override any defaults with built-in terraform vars mechanism.

Just create terraform.tfvars from dist and override defaults:
```shell
cd terraform/digital_ocean
cp terraform.tfvars.dist terraform.tfvars
```
## Clouds
### Digital Ocean
You have to generate access token and set it to local env variable.
After that go to terraform/digital_ocean directory and init provider.
```shell
export DIGITALOCEAN_ACCESS_TOKEN="<CHANGE TO YOUR PERSONAL ACCESS TOKEN>"
cd terraform/digital_ocean
terraform init
```
Configuration options (set in terraform.tfstate):
* instance_count - cound of droplets to be running
* instance_region - default is Frankfurt
* instance_type - default is the cheapest droplet type/size "s-1vcpu-1gb" with 1 CPU and 1GB RAM
### AWS
todo
## Runners
### alpine/bombardier
This is default runner.
Configuration options (set in terraform.tfstate):
* runner_bombardier_connections_per_resource
* runner_bombardier_duration
### mhddos and others
todo
## Resources
Resources is a text file containing tested URLs one per line. Example:
```text
http://localhost
https://127.0.0.1
```
### Remote
Resources list is located on remote machine and is loaded once instance is provisioned.
Each instance/droplet recreation will re-download resources file.

Configuration options:
* runner_resources_url
### Local
Place resources/resources.txt locally.

Change configuration option:
* runner_resources_mode_is_remote = false

You don't need to specify runner_resources_url anymore.

## Running
When everything is configured go to appropriate cloud directory and deploy infrastructure with runners, for example:
```shell
cd terraform/digital_ocean
terraform apply
# type "yes"
```
To recreate instances (for re-reading of remote/local resources file or for changing the region) execute commands:
```shell
terraform destroy
# type "yes"
terraform apply
# type "yes"
```
Be aware: instance recreation may affect it's IP changing.

For some configuration changes (not regarding runners/inside-instance-provisioning) you need only apply them:
```shell
terraform apply
# type "yes"
```
