const puppeteer = require("puppeteer");
const axios = require("axios");
const cheerio = require("cheerio");

async function scrapeData() {
  try {
    const browser = await puppeteer.launch({ headless: "false" });

    const page = await browser.newPage();
    await page.goto("https://blog.naver.com/seungwanwin/222909982869");
    const iframeSelector = 'iframe[name="mainFrame"]';
    const iframeElementHandle = await page.$(iframeSelector);

    const iframe = await iframeElementHandle.contentFrame();
    const textInIframe = await iframe.evaluate(() => {
      return document.documentElement.innerHTML;
    });
    console.log(textInIframe);
    console.log("----------");

    const $ = cheerio.load(textInIframe);
    // const content = $(
    //   "#postBottomTitleListBody > tr:nth-child(1) > td.title > div > span > a"
    // );
    // console.log(content);
    // await iframeContent.screenshot({ path: "example.png" });

    await browser.close();
  } catch (error) {
    console.error(error);
  }
}

scrapeData();
