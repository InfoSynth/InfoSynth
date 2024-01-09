const axios = require("axios");
const cheerio = require("cheerio");
const iconv = require("iconv-lite");

const getGoogleHtml = async () => {
  const articles = [];
  try {
    const key = "클래식앱";
    const url =
      "https://news.google.com/search?q=" + key + "&hl=ko&gl=KR&ceid=KR%3Ako";
    for (var i = 1; i <= 8; i++) {
      //   console.log(url);

      const html = await axios.get(url, {
        responseType: "arraybuffer",
        responseEncoding: "binary",
      });
      const content = iconv.decode(html.data, "UTF-8");
      const $ = cheerio.load(content);
      const bodyList = $(
        "#yDmH0d > c-wiz:nth-child(25) > div > main > div.UW0SDc > c-wiz > c-wiz:nth-child(" +
          i +
          ") > c-wiz > article > div.m5k28 > div.XlKvRb > a"
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

getGoogleHtml();
