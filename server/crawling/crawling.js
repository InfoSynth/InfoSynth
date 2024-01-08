const puppeteer = require("puppeteer");

async function scrapeData() {
  try {
    const browser = await puppeteer.launch({ headless: "false" });

    const page = await browser.newPage();

    await page.goto("https://blog.naver.com/seungwanwin/222976751098");
    await page.waitForTimeout(5000);

    // const frame = page.frames().find((frame) => frame.name() === "mainFrame");
    const iframeElementHandle = await page.$('iframe[name="mainFrame"]');

    console.log(iframeElementHandle.content);
    // const ele = await frame.$(
    //   "#listTopForm > table > tbody > tr.on > td.title > div > span > a"
    // );
    // let evalData = await page.evaluate((element) => {
    //   return element.textContent;
    // }, ele);
    // console.log(evalData);

    await browser.close();
  } catch (error) {
    console.error(error);
  }
}

scrapeData();
