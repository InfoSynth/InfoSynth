const axios = require("axios");
const cheerio = require("cheerio");
const iconv = require("iconv-lite");

const getSearchHtml = async (key) => {
  const articles = [];
  try {
    // const key = "클래식앱";
    const url =
      "https://search.naver.com/search.naver?where=news&sm=tab_tnw&query=" +
      key +
      "&sort=0&photo=0&field=0&pd=0&ds=&de=&mynews=0&office_type=0&office_section_code=0&news_office_checked=&related=1&nso=so:r,p:all,a:all";
    for (var i = 1; i <= 8; i++) {
      console.log(url);

      const html = await axios.get(url, {
        responseType: "arraybuffer",
        responseEncoding: "binary",
      });
      const content = iconv.decode(html.data, "UTF-8");
      const $ = cheerio.load(content);
      const bodyList = $(
        "#sp_nws" + i + " > div > div > div.news_contents > a.news_tit"
      );
      if (bodyList.text() != "") articles.push(bodyList.text());
    }
    console.log(articles);
    return articles;
  } catch (error) {
    console.log(articles);
    // console.error(error);
    return {};
  }
};

// getSearchHtml("인공지능");

module.exports = { getSearchHtml };
