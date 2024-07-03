# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## 2022-12-07
### Added
- Repository restructured according to the the ODP.

## 2022-10-11
### Added
 - Add Account-baseline configuration and apply consistently across all accounts.

## 2022-08-23
### Fixed
- Update action to run terraform in all environment directories except commons directory.

## 2022-08-23
### Added
- Created log archive bucket for project environments.

## 2022-08-09
### Added
- Create SCP policy to enforce Tag policy.

## 2022-08-05
### Added
- Deploy codebuild project for workload accounts deployment

## 2022-08-04
### Fixed
- Remove VPC public resources if not needed.

## 2022-08-02
### Added
- Deploy AWS Client VPN service.

## 2022-08-01.2
### Added
- Create assume roles for GitHub Actions user.

## 2022-08-01.1
### Added
- Dynamically associate spoke VPC attachments with Association TGW RT and propagate spoke VPC attachments to Propagation TGW RT.

## 2022-07-27.2
### Added
- Add AWS SSO Permission Sets and associate with accounts.

## 2022-07-27.2
### Added
- Move tag policy content to template file.
- Add organization tag policy module

## 2022-07-27.1
### Added
- Attach Shared-Services Pipeline VPC to TGV and route private traffic to Egress VPC.

## 2022-07-26.2
### Added
- Deploy VPC to Shared-Services Account for deploy pipeline.

## 2022-07-26.1
### Added
- Create organization level SCP to enforce tag policy

## 2022-07-25
### Added
- Create organization level tag policy

## 2022-07-22
### Fixed
- fix: update Transit Gateway route tables

## 2022-07-21
### Added
- Network resources for shared-services account.
- Egress VPC and Transit Gateway for Networking account.

## 2022-07-20
### Added
- Deploy codebuild project in Shared account to run future pipelines on it

## 2022-07-19
### Added
- Establish a codebase for further development


Types of changes:
- Added for new features.
- Changed for changes in existing functionality.
- Deprecated for soon-to-be removed features.
- Removed for now removed features.
- Fixed for any bug fixes.
- Security in case of vulnerabilities.
