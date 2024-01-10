const puppeteer = require("puppeteer-extra");
const StealthPlugin = require("puppeteer-extra-plugin-stealth");

puppeteer.use(StealthPlugin());

var { executablePath } = require("../.private");

const videoLink = "https://www.youtube.com/"; // 동영상 페이지 링크

const getALLYoutubeVideoTitle = async () => {
  const browser = await puppeteer.launch({
    executablePath: executablePath, // Chrome 실행 경로
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  });

  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(60000);
  const videoLink = "https://www.youtube.com/";
  await page.goto(videoLink, { waitUntil: "networkidle2" });

  strg = "#video-title-link";

  const titles = await page.evaluate((selector) => {
    const titleElements = document.querySelectorAll(selector);
    const titlesArray = [];
    titleElements.forEach((element) => {
      const text = element.textContent.trim();
      const url = element.href;
      console.log(url);
      titlesArray.push({ text, url });
    });
    return titlesArray;
  }, strg);

  await browser.close();
  return titles;
};

module.exports = { getALLYoutubeVideoTitle };

getALLYoutubeVideoTitle(videoLink).then((title) =>
  console.log("Content:", title)
);
