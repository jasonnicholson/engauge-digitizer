## **14.0.0-beta.1**&emsp;<sub><sup>2026-04-12 ([94e9815...d417e1c](https://github.com/jasonnicholson/engauge-digitizer/compare/94e9815641e25c27e691d8ce4bad2c66a3b52d85...d417e1ce27982c17e1708190dbe3e539be26077f?diff=split))</sup></sub>

### Build System

- wire 16 Qt unit tests as CTest targets; fix Qt6 test failures ([87132ff](https://github.com/jasonnicholson/engauge-digitizer/commit/87132ff098222ce57a1008ec5cb3ef6d624d6ea2))
- add CLI regression test runner; update Qt6 expected outputs ([12188ac](https://github.com/jasonnicholson/engauge-digitizer/commit/12188ac10c042d8e76af99cacc5466f55ba8f2b3))
- enable JPEG2000/PDF for Linux\+MXE and fix MXE poppler link ([13e2f01](https://github.com/jasonnicholson/engauge-digitizer/commit/13e2f010bbb4c44db61c25161a075fae3f4268e9))
- remove PDF/poppler support, decouple tests from MainWindow ([563868e](https://github.com/jasonnicholson/engauge-digitizer/commit/563868eed3398397237604d529ef71cb2b78c273))
- remove almost\-static build, fix QCursor for Qt6, clean up legacy files ([8533851](https://github.com/jasonnicholson/engauge-digitizer/commit/8533851c72e10b593682594a02a7826525db3299))
- adopt Conan as the primary Linux dependency flow ([ca21212](https://github.com/jasonnicholson/engauge-digitizer/commit/ca212123026c355121559daeeafb8b46d2f418a3))
- adopt Conan as the Windows dependency manager ([176f815](https://github.com/jasonnicholson/engauge-digitizer/commit/176f81585889a179cfbe230b54af868a35546a0c))
- fix Conan warnings and Windows cross\-build resolution ([c486a13](https://github.com/jasonnicholson/engauge-digitizer/commit/c486a134ff88a2df1d7b1ed33280a2965c7da23a))
- Setting up a deploy pipeline for calculating the version, compiling, packaging, changelog update, deploying docs, and creating a GitHub release\. ([b4f75cf](https://github.com/jasonnicholson/engauge-digitizer/commit/b4f75cfac0fc96770acc1b928b95d74838675fb9))
- Enabling beta version in the release pipeline\. ([20570ff](https://github.com/jasonnicholson/engauge-digitizer/commit/20570ff1e794ae720284ed2c09e6d56034f747d2))
- Deploy script was modifying version script in package\.json\. ([d417e1c](https://github.com/jasonnicholson/engauge-digitizer/commit/d417e1ce27982c17e1708190dbe3e539be26077f))

### Documentation

- regenerate changelog from repaired v13\.0\.0 tag ([6b8634e](https://github.com/jasonnicholson/engauge-digitizer/commit/6b8634e56ac3d6d365f2e15186bfd37c380cd1cb))
- refresh Linux/Windows build guide for JPEG2000 and poppler\-qt6 ([30bafd4](https://github.com/jasonnicholson/engauge-digitizer/commit/30bafd46ffd8babe0a44c039501a456957924747))
- Readme proof reading\. ([2c34573](https://github.com/jasonnicholson/engauge-digitizer/commit/2c34573708a8e07b1ac4f70001f6d8384ad892b2))
- add Windows MXE\+Qt6 prerequisite setup section ([a226b1d](https://github.com/jasonnicholson/engauge-digitizer/commit/a226b1dcbb094710d4db5a1d7ccde6f4e839111f))
- Working updating outdated documentation\. There is a lot\. ([01b58ea](https://github.com/jasonnicholson/engauge-digitizer/commit/01b58ead5782f115e267b589362dcd36e68e8dfc))
- Added a note about how out of date the documentation is\. ([7d7fbae](https://github.com/jasonnicholson/engauge-digitizer/commit/7d7fbae832b380a2abf4685107aa8c1251af0608))
- Updating documentation pages based on code\. ([4314f41](https://github.com/jasonnicholson/engauge-digitizer/commit/4314f415b9d84a25c50bb2f76c415dc356b31195))

##### &ensp;`README.md`

- Explain "Why?" this project exists\. ([a83e33f](https://github.com/jasonnicholson/engauge-digitizer/commit/a83e33fbbd7d5c1ce01161e37cee9cc087941ed8))
- Clarifying installers\. ([ea0f786](https://github.com/jasonnicholson/engauge-digitizer/commit/ea0f78606a6085b1b399975db51a2f550072dd24))

##### &ensp;`cli.rst`

- Updated stale cli documentation\. ([9cba796](https://github.com/jasonnicholson/engauge-digitizer/commit/9cba7962f1fb28ac05d428b1eea927846167d96a))

### Features

- migrate to Qt6 and CMake ([b0fa567](https://github.com/jasonnicholson/engauge-digitizer/commit/b0fa567ac8965c898756f63d2e1afef652d20ac7))

### Bug Fixes

- Qt6 source compatibility \(Qt 6\.2\.4 API fixes\) ([92998e3](https://github.com/jasonnicholson/engauge-digitizer/commit/92998e3d4f110c80dc9c029ace3a54c96cfe6a1e))
- stub MySQL/PostgreSQL targets and exclude SQL plugins for cross\-compile ([e79d85f](https://github.com/jasonnicholson/engauge-digitizer/commit/e79d85fa107fad9a337f1211516c8b4f7610e771))
- Qt5→Qt6 locale migration: store locale as BCP47 name not integer enums ([4f88433](https://github.com/jasonnicholson/engauge-digitizer/commit/4f88433d8279ded200c81746225840f752574a36))
- disable BUILD\_TESTING for MXE Windows cross\-compile ([d7668bb](https://github.com/jasonnicholson/engauge-digitizer/commit/d7668bb29b3026e8a42f7da678e042ca7bc11811))
- port SIGNAL/SLOT connections to Qt6 \(activated, valueChanged, currentIndexChanged\) ([29d467e](https://github.com/jasonnicholson/engauge-digitizer/commit/29d467e4a8cfc040600c6a81e70344369fe6ea0b))
- resolve Qt6 deprecation warnings, QThread crash, and PDF cropping remnant ([767f32f](https://github.com/jasonnicholson/engauge-digitizer/commit/767f32f72e46d7f7830a31087e5f1387565e8f24))
- eliminate remaining MXE cmake warnings and Qt6 deprecations ([6a1c70b](https://github.com/jasonnicholson/engauge-digitizer/commit/6a1c70bb6dfa511d8a0e476459614f1b3c86ab4a))
- simplify ColorPicker cursor to avoid QBitmap on Qt6 ([7c430ae](https://github.com/jasonnicholson/engauge-digitizer/commit/7c430ae28043dbfc6f4ba1fa4fd2ed4ccf26dd07))
- stabilize cursor handling and shutdown path on Linux ([9e41ec7](https://github.com/jasonnicholson/engauge-digitizer/commit/9e41ec7adcbb4fa5c0947ea77c91fb1e4bc1dcda))


### BREAKING CHANGES
-  migrate to Qt6 and CMake ([b0fa567](https://github.com/jasonnicholson/engauge-digitizer/commit/b0fa567ac8965c898756f63d2e1afef652d20ac7))
<br>

## **13.0.0**&emsp;<sub><sup>2026-04-09 ([bbf02cf...96940ed](https://github.com/jasonnicholson/engauge-digitizer/compare/bbf02cf7d11ec3145dca6071b9119f23260e27f9...96940ed06f12cbd1177aadb9085c5e570aa1410b?diff=split))</sup></sub>

### Build System

- produce almost\-static Linux bundle from /opt Qt ([96940ed](https://github.com/jasonnicholson/engauge-digitizer/commit/96940ed06f12cbd1177aadb9085c5e570aa1410b))

### Documentation

- add MXE windows build and Linux Qt runtime guidance ([13d4aea](https://github.com/jasonnicholson/engauge-digitizer/commit/13d4aeac4f37502ae8d8af535e0394d4ea3f749c))
- clarify static builds and release workflow ([100aaaf](https://github.com/jasonnicholson/engauge-digitizer/commit/100aaaf2fc9b71679633909b7cf4b22388e9c39e))
- refresh readme and modernize build guidance ([ff1b137](https://github.com/jasonnicholson/engauge-digitizer/commit/ff1b13733ff5df9caad7d6ff360b8c549c383421))
- scaffold sphinx site and start page migration ([e5228d7](https://github.com/jasonnicholson/engauge-digitizer/commit/e5228d73f1e9a22ce53cf9398c02397a6d4f50c1))
- migrate cli, coordinates, export, and tutorial pages ([d06dc16](https://github.com/jasonnicholson/engauge-digitizer/commit/d06dc161674f4580261cc82306763499ba165195))
- migrate dialogs reference and faq pages ([c0e38dd](https://github.com/jasonnicholson/engauge-digitizer/commit/c0e38dd746a698f51c2e92bbc81dbaf79d4bb99d))
- migrate glossary and remaining FAQ pages to Sphinx \(batch 4\) ([099487f](https://github.com/jasonnicholson/engauge-digitizer/commit/099487f43cc30d34f6848fb36b1390bb5e19f402))
- remove obsolete ODT files, add community page ([c225bd4](https://github.com/jasonnicholson/engauge-digitizer/commit/c225bd4cbc646a884af3a712a6e0ba77a83e29d4))
- migrate root MDs to Sphinx, update URLs, simplify privacy policy ([5ff601e](https://github.com/jasonnicholson/engauge-digitizer/commit/5ff601e303cc7e24bd752474414ddec575cb5503))
- add deploy\.sh using git commit\-tree for orphan gh\-pages ([258510b](https://github.com/jasonnicholson/engauge-digitizer/commit/258510bb1ec6bf54e0d3416a5ee7ebfcc8fa7a81))

### Features

- redirect Help menu to online Sphinx docs via QDesktopServices ([6debcfa](https://github.com/jasonnicholson/engauge-digitizer/commit/6debcfa2efe0373e91e43f07132920c8388de14d))
- add almost\-static Linux build targeting self\-built Qt ([aae0d89](https://github.com/jasonnicholson/engauge-digitizer/commit/aae0d89ee3916b51e70f84ef11e23bab8d35e648))

### Bug Fixes

- update About dialog \- new repo URL, remove Gitter, update copyright ([d9b1c43](https://github.com/jasonnicholson/engauge-digitizer/commit/d9b1c43f187b375558c1bd6505acfbe840c180b1))

<br>

