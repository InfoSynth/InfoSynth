const axios = require("axios");
const cheerio = require("cheerio");
const iconv = require("iconv-lite");

const getYoutubeHtml = async () => {
  try {
    const articles = [];
    const url = "https://www.youtube.com/watch?v=-Ysl10EH_4k";

    const html = await axios.get(url, {
      responseType: "arraybuffer",
      responseEncoding: "binary",
    });

    const content = iconv.decode(html.data, "UTF-8");
    const $ = cheerio.load(content);
    // console.log($.html());
    const bodyList = $("#title > h1 > yt-formatted-string");
    console.log(bodyList.text());
    articles.push(bodyList.text());

    return articles;
  } catch (error) {
    console.error(error);
    return {};
  }
};

module.exports = { getYoutubeHtml };

getYoutubeHtml();
