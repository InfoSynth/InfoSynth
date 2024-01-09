const axios = require("axios");
const cheerio = require("cheerio");
const iconv = require("iconv-lite");

const getNewsHtml = async () => {
  try {
    const articles = [];
    const urls = [
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=100",
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=101",
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=102",
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=103",
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=104",
      "https://news.naver.com/main/main.naver?mode=LSD&mid=shm&sid1=105",
    ];
    for (var i = 0; i < 6; i++) {
      const html = await axios.get(urls[i], {
        responseType: "arraybuffer",
        responseEncoding: "binary",
      });
      const content = iconv.decode(html.data, "EUC-KR");
      const $ = cheerio.load(content);
      const bodyList = $(
        "#main_content > div > div._persist > div.section_headline > ul > li"
      );
      bodyList.each((index, element) => {
        const title = $(element).find("div.sh_text > a").text().trim();
        const link = $(element).find("div.sh_text > a").attr("href");
        articles.push({ title, link });
      });
    return articles;

  } catch (error) {
    console.error(error);
    return {};
  }
};
module.exports = { getNewsHtml };

