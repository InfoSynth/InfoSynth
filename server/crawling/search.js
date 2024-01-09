const axios = require("axios");
const cheerio = require("cheerio");
const iconv = require("iconv-lite");

const getSearchHtml = async (key) => {
  console.log("getSearchHtml started");
  const url =
    "https://search.naver.com/search.naver?where=news&sm=tab_tnw&query=" +
    key +
    "&sort=0&photo=0&field=0&pd=0&ds=&de=&mynews=0&office_type=0&office_section_code=0&news_office_checked=&related=1&nso=so:r,p:all,a:all";
  // console.log(url);
  const articles = [];
  try {
    for (var i = 1; i <= 8; i++) {
      const html = await axios.get(url, {
        responseType: "arraybuffer",
        responseEncoding: "binary",
      });
      const content = iconv.decode(html.data, "UTF-8");
      const $ = cheerio.load(content);
      const bodyList = $(
        "#sp_nws" + i + " > div > div > div.news_contents > a.news_tit"
      );
      if (bodyList.text() != "") {
        // console.log(bodyList.text());
        // console.log(bodyList.attr("href"));
        var title = bodyList.text();
        var link = bodyList.attr("href");
        articles.push({ title, link });
      }
    }
    console.log(articles);
    return articles;
  } catch (error) {
    console.log(articles);
    // console.error(error);
    return {};
  }
};

getSearchHtml("카이스트");

module.exports = { getSearchHtml };
