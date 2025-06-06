# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [4.3.0] - 2025-04-15

### Added

- Support Ireland

### Removed

- Remove eol Ruby 3.1

## [4.2.0] - 2024-08-18

### Added

- Support Belgium

### Removed

- Remove eol Rubies

## [4.1.0] - 2023-01-23

### Added

- Support Egypt, Poland, Saudi Arabia, and Sweden

## [4.0.0] - 2021-05-27

### Changed

- Relax version requirement on the HTTP gem

## [3.4.1] - 2020-07-10

### Removed

- Remove validation for resource attribute

## [3.4.0] - 2020-05-27

### Added

- Add validation for resources attribute
- Add validation for keywords attribute in Request#item_search
- Add support for EditorConfig
- Add support for RSpec
- Expose the chainable methods of HTTP to allow logging and other potentially useful features
- Add Netherlands

### Removed

- Remove support for end-of-life'd Ruby 2.4

## [3.3.0] - 2020-01-26

### Added

- Add Singapore

### Fixed

- Support Ruby 2.7

## [3.2.0] - 2019-11-13

### Added

- bring your own parser for Vacuum::Response

## [3.1.0] - 2019-11-10

### Changed

- Swap HTTPI with the HTTP gem

### Added

- Allow persistent connections

## [3.0.0] - 2019-10-30

This is a major version release. It's a backward-incompatible rewrite following the roll-out of the [new Amazon Product Advertision API version 5](https://webservices.amazon.com/paapi5/documentation/migration-guide.html).

### Changed

- Migrate to Product Advertising API version 5

[Unreleased]: https://github.com/hakanensari/vacuum/compare/v4.3.0...HEAD
[4.3.0]: https://github.com/hakanensari/vacuum/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/hakanensari/vacuum/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/hakanensari/vacuum/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/hakanensari/vacuum/compare/v3.4.1...v4.0.0
[3.4.1]: https://github.com/hakanensari/vacuum/compare/v3.4.0...v3.4.1
[3.4.0]: https://github.com/hakanensari/vacuum/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/hakanensari/vacuum/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/hakanensari/vacuum/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/hakanensari/vacuum/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/hakanensari/vacuum/compare/v2.2.0...v3.0.0
