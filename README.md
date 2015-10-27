# checked_service

#### Table of Contents

1. [Overview](#overview)
2. [Version History](#version-history)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with checked_service](#setup)
    * [What checked_service affects](#what-checked_service-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with checked_service](#beginning-with-checked_service)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module is a proof of concept demonstrating a way to have puppet manage services with external dependencies. This is accomplished by describing the checked service in Hiera and classifying nodes with this module. Puppet will then perform one or more Zabbix checks before attempting to start the checked service. Puppet verifies those services keep running over time through regular puppet runs and will log dependency failures if and when they are encountered.

This module also provides an MCollective framework allowing operators to issue commands specific to a checked service, such as having all servers running the XYZ application lock the puppet agent and shutdown one or more XYZ services. (This may aid efforts around scheduled maintenance.) Alternately, they can unlock the puppet agent and on the next run, Puppet will idempotently start the services after the Zabbix checks pass.

## Version History

| Version  | Date  | Author(s)  | Notes                                          |
|:----------:|:----------:|------------|------------------------------------------------|
| 1.0.0  | Oct 30, 2015  | Gabriel M. Schuyler (gabe@puppetlabs.com) and Paul K. Anderson (paul.anderson@puppetlabs.com) | Initial Version  |
|        |               |    |   |
|   |   |   |   |
## Module Description

This module was developed against Puppet Enterprise 3.7.2. Some changes related to accomodate the parser are expected if and when Puppet Enterprise is upgraded to 2015.2 or later. Additionally, use of the pe_gem is deprecated in favor of puppet_gem in 2015.2 or later.

This module contains a number of integration points:

1. A Zabbix environment with triggers that represent one (or more) dependencies that must be met before Puppet should start a service on a target node. (For instance a fileserver or database must be available before starting an application's daemon, otherwise "bad things would happen".)
1. The zabby gem (https://github.com/Pragmatic-Source/zabby) is installed in the puppet environment to ensure maximum cross-platform compatability
1. Zabbix connection information (user, pass, IP, etc.) must be populated in Hiera (or perhaps params.pp, calling it as a parameterized class, etc.) 
1. Checked Services must be defined in Hiera. The authors intend to accomodate per-service definition that can be delegated to various app teams within the organization. This allows each team to configure the number of checks, timeout values, which zabbix checks should be run before starting the service, etc.
1. An ERB template will create a script (zbx-query.rb) based on the provided Zabbix connection information. This script will contain the values necessary to make a Zabbix trigger query. It will be run once per checked service check with a list of triggers to check. If all triggers come back as passing, the script will exit with a status of 0, telling Puppet that everything is fine and it can start the service. If one or more triggers indicates a failure, the script will exit with a status of 1 and Puppet will skip trying to start the service. If some other error is encountered (for instance, a trigger name is mispelled.) the script will end with an exit code of 99 or greater. Any failure should record the exit code in the puppet logs for future reference/troubleshooting
1. The Zabbix-specific code in zbx-query.rb is very heavily based on Zabby's trigger.zby code. In the event troubleshooting is necessary, the output from both scripts may be useful to compare and contrast.
1. This module will distribute mcollective agents to classified nodes, allowing mcollective features related to this module to function


## Setup

### What checked_service affects

#### Files, Directories, Packages affected by this module:

1. Zabby version 0.1.2 will be installed in the PE ruby distribution
2. The Check Service Script will be managed (/tmp/zbx-query.rb by default)
3. The MCo class will create two files:
    * ${checked_service::mco_lib_path}/agent/checked_service.ddl
    * ${checked_service::mco_lib_path}/agent/checked_service.rb

#### Other effects:
4. This service will start managed services if the Check Service Script returns with an exit code of 0.

### Setup Requirements

The provider module puppetlabs/pe_gem is a prerequisite to this.

A Zabbix server with appropriate triggers that will identify dependencies your service requires

A Zabbix proxy. (This module was not tested with direct access to Zabbix. It may work.)

### Beginning with checked_service

1. Install this module on a test system
2. If necessary, use Puppet's Package, File, Service pattern to install and configure the target service on the test system
3. Identify one or more Zabbix triggers that, when in a satisfactory state (i.e. zabby trigger.zby returns 0 when queried) can serve as the dependencies for your service
4. Add Zabbix connection info to an appropriate level in Hiera (datacenter/site, perhaps?)
5. Create a checked service definition in Hiera (presumably for a specific node, application group or role)
6. Classify one or more nodes with this checked_service class
7. Kick off the puppet agent run
8. Monitor the output. Troubleshoot any errors. The exit status of zbx-query.rb should be helpful as to the nature of the problem. use zabby trigger.zby to troubleshoot Zabbix issues.

## Usage

* Configure the necessary parameters for the Service Check Script to be able to query trigger status, like this (Consider putting this in a broader scope, such as datacenter, site or enterprise):

    ```
    checked_service::zabbix_api_url: https://zabbix.puppetlabs.vm/zabbix/api_jsonrpc.php
    checked_service::zabbix_user: admin
    checked_service::zabbix_pass: 'zabbix' #eyaml is your friend
    checked_service::zabbix_proxy: http://proxy.puppetlabs.vm:8000

* Define a checked service in Hiera, like this (Consider putting this in a smaller scope, such as node, group of nodes, or role):

    ```
    checked_service::services:
      service1:
          ensure: 'running'
          enable: 'yes'
          checker_tries: 1
          checker_timeout: 10
          checker_arguments:
           'host1,trigger description 1,
            host2,trigger description 2,
            host3,trigger description 3,
            host4,trigger description 4,
            host5,trigger description 5'
      service2:
          ensure: 'running'
          enable: 'yes'
          checker_tries: 1
          checker_timeout: 10
          checker_arguments:
           'host6,trigger description 6,
            host7,trigger description 7,
            host8,trigger description 8,
            host9,trigger description 9,
            hostA,trigger description A'
            
* Classify one or more nodes in that same hiera scope as the service definition with one or more checked_service::service defined resource types, ensure the service_name parameter matches what you put in hiera (e.g. service1) and use to your heart's content.

*Once this is done, the MCollective agents can be used to lock Puppet and stop the managed services, such as for maintenance. MCollective can later be used to unlock Puppet, which will restore the services back to the usual state. 

## Reference

### Classes

####checked_service 


|   **Parameters**	 |	 **Description**  |
|:------------------:|:------------------|
| *$script_dir*      | The parent directory where the service check script will be placed (Default: Platform-specific from params)|
| *$script_name*     | The name of the service check script. Assumes a corresponding template (default: zbx-query.rb)|
| *$script_template* | The name of the template that will be used to generate the service check script (without .erb extension; default: $script_name)|
| *$script_owner*    | The owner of the service check script (Default: Platform-specific from params)|
| *$script_group*    | The group of the servcie check script (Default: Platform-specific from params)|
| *$path_to_ruby*    | The path to the Puppet Enterprise Ruby binary (Default: Platform-specific from params)|
| *$mco_lib_path*    | The path to the directory where MCollective agents should be placed (Default: Platform-specific from params)|
 
####checked_service::mco
|   **Parameters**	 |	 **Description**  |
|:------------------:|:------------------|
| none | n/a | 

####checked_service::params

As with most Params classes, this contains some logic to set required values on a per-platform basis. It also contains a few other variables that can be set on a per-site basis. They are identical to the parameters for the checked_service class.

### Types

####checked_service::service
|   **Parameters**	 |	 **Description**  |
|:------------------:|:------------------|
| $service_name          | $title **(namevar)** |
|  $ensure                | Same as Service resource (Default: 'running')|
|  $enable                | Same as Service resource (Default: true)|
|  $checker_argument      | A comma separated string of zabbix trigger host and zabbix trigger description pairs (See sample Hiera file)|
|  $checker_tries         | The number of times the service check script should be run before finally failing (Default: 4)|
|  $checker_timeout       | The length of time in minutes the service check script can take before being terminated and treated as a failure (Default: 60)|

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

### MCollective Agents

**TODO: Need Content Here**

## Limitations

* Module developed for Puppet Enterprise 3.7.2 (Changes will be required to make it work with Puppet 4)
* Module tested against Enterprise Linux 6 and Windows Server 2008 R2
* Module developed as a proof of concept and to match a specific use case. It may not have general applicability, may not be maintained after initial release and may not represent the best practices or prefered usage models of puppet code.

## Development

Pull requests are welcome, but active development by the original authors is likely to stop after delivery of the first release.

## Release Notes/Contributors/Etc

### Contributors:

Gabriel M. Schuyler (gabe@puppetlabs.com) is a Sr. Professional Services Engineeer and lead architect for this module. Gabe developed the Puppet and MCollective code associated with this module.

Paul K. Anderson (paul.anderson@puppetlabs.com) is with Puppet Labs Professional Services and performed the porting of trigger.zby to the zbx-query ERB template and subsequent enhancements.


