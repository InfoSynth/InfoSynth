# InfoSynth
*2023 Winter MadCamp Second Project*

## Outline
<img src="https://github.com/InfoSynth/InfoSynth/assets/113894257/6e4c6cc7-7a58-4e2e-bc4b-da8975d70ef1" width="200"></img>

<br/>

**InfoSynth**는 편향되거나 제한된 정보에 노출된 사용자들이 객관적이고 다양한 관점을 갖는 정보를 얻을 수 있도록 도와주는 앱입니다. 유튜브 동영상을 기반으로 작동하며, 사용자가 유튜브 영상의 URL을 입력하면 해당 영상의 스크립트를 크롤링하여 영상과 관련된 기사를 제공합니다.

<br/>

## Team
**강승완** <a href="https://github.com/albertruaz" target="_blank"><img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"></a>

**나지연**  <a href="https://github.com/najiyeon" target="_blank"><img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"></a>

<br/>

## Tech Stack
**Front-end** : Flutter(Dart)

**Back-end** : Node.js, MySQL

<br/>

## About
**유튜브 영상 목록**
- 최근 유튜브 영상들을 크롤링으로 받아와 목록을 보여줍니다.
- 영상 클릭 후 시청시 자동으로 '기사 검색' 탭에서 최근 시청한 영상에 해당하는 기사들을 보여줍니다.

**기사 검색**
- 사용자가 입력한 유튜브 영상의 URL을 기반으로 해당 영상의 스크립트를 크롤링합니다.
- 크롤링한 스크립트를 GPT에 입력하여 키워드를 추출합니다.
- 추출된 키워드를 활용하여 네이버 기사를 검색하고, 각 키워드에 대한 주요 기사 몇 개를 앱에 리스트로 제공합니다.
- 사용자가 리스트에서 선택한 기사를 클릭하면 해당 기사에 대한 인터넷 링크로 연결됩니다. 

**마이 페이지**
- 기본 정보를 확인하고, 수정할 수 있습니다.
- 자신이 최근 검색한 영상의 주요 키워드를 최근 관심사 해시태그로 확인할 수 있습니다.


