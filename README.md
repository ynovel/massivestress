# Massive Stress
Multi-Cloud Multi-Runner Stress Test Tool.

This tool is created for purpose of convenient stress testing to measure performance and reliability of systems.

The idea is to have flexibility to choose any combination of:
* **Cloud provider**, choose what your organization already use: DO, AWS etc.
* **Runner**: alpine/bombardier, mhddos, dripper.py etc.
* **Resources** list - choose what is more convenient for your type of deployment: remote dedicated source or local file.

All parameters such as instances count, connections counts could be **configured**.
## Installation
This tool is working on cloud infrastructures, which are setup and provisioned with Terraform.
Parameters could be changed from defaults and configured via terraform.tfvars.


### Mac
```shell
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```
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
export DIGITALOCEAN_ACCESS_TOKEN="your_personal_access_token"
cd terraform/digital_ocean
terraform init
```
Configuration options (set in terraform.tfstate):
* instance_count - cound of droplets to be running
* instance_region - default is Frankfurt
* instance_type - default is the cheapest droplet type/size "s-1vcpu-1gb" with 1 CPU and 1GB RAM  
## Runners
### alpine/bombardier
This is default runner.
Configuration options (set in terraform.tfstate):
* runner_bombardier_connections_per_resource
* runner_bombardier_duration
## Resources
### Remote
Configuration_options:
* runner_resources_url
### Local
todo

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
For some configuration changes (not regarding runners/inside-instance-provisioning) you need only apply them:
```shell
terraform apply
# type "yes"
```
