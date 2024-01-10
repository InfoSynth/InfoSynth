const puppeteer = require("puppeteer-extra");
const StealthPlugin = require("puppeteer-extra-plugin-stealth");

var { executablePath } = require("../.private");

puppeteer.use(StealthPlugin());

const videoLink = "https://www.youtube.com/watch?v=p3HQJRKAkZ8"; // 동영상 페이지 링크

const getYoutubeVideoTitle = async (videoLink) => {
  console.log("youtube.js started: ", videoLink);
  try {
    const browser = await puppeteer.launch({
      executablePath: executablePath, // Chrome 실행 경로
      headless: true,
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });
    console.log("puppeteer.launch started");
    const page = await browser.newPage();
    console.log("newPage started");
    // await page.setDefaultNavigationTimeout(8000);
    page.setDefaultNavigationTimeout(0);
    console.log("setDefaultNavigationTimeout started");
    // await page.goto(videoLink, { waitUntil: "networkidle0" });
    await page.goto(videoLink, { waitUntil: "load", timeout: 0 });
    console.log("goto started");
    try {
      await page.waitForSelector("#attributed-snippet-text");
      // Additional actions if the selector is found
    } catch (error) {
      console.error("Error in finding the selector:", error);
      return ""; // Return a blank string in case of an error
    }

    const expandSelector = "#expand";
    try {
      await page.waitForSelector(expandSelector);
      console.log("Button found, attempting to click...");
      await page.click(expandSelector);
      console.log("Button clicked successfully.");
      await page.waitForSelector(
        "#description-inline-expander > yt-attributed-string > span > span:nth-child(4)"
      ); // 해당 요소가 로드될 때까지 기다립니다.
      try {
        // await page.click(
        //   "#primary-button > ytd-button-renderer > yt-button-shape > button > yt-touch-feedback-shape > div > div.yt-spec-touch-feedback-shape__fill"
        // );
        await page.evaluate((selector) => {
          document.querySelector(selector).click();
        }, "#primary-button > ytd-button-renderer > yt-button-shape > button > yt-touch-feedback-shape > div > div.yt-spec-touch-feedback-shape__fill");
      } catch (error) {
        console.error("스크립트 클릭버튼이 없어요");
        console.error(error);

        var articles = "";
        for (var i = 1; i < 100; i++) {
          const strg =
            "#description-inline-expander > yt-attributed-string > span > span:nth-child(" +
            i +
            ")";
          const title = await page.evaluate((strg) => {
            const titleElement = document.querySelector(strg);
            return titleElement ? titleElement.innerText : null;
          }, strg);
          // console.log(i, ": ", title);
          if (title != null) articles += title;
        }
        await browser.close();
        return articles;
      }

      // console.log("Script clicked successfully.");
      await page.waitForSelector(
        "#segments-container > ytd-transcript-segment-renderer:nth-child(19) > div > yt-formatted-string"
      );
      console.log("Finished Waiting");
    } catch (error) {
      console.error("Error in clicking the button:", error);
      await browser.close();
      return "";
    }
    var articles = "";
    for (var i = 1; i < 100; i++) {
      const strg =
        "#segments-container > ytd-transcript-segment-renderer:nth-child(" +
        i +
        ") > div > yt-formatted-string";
      const title = await page.evaluate((strg) => {
        const titleElement = document.querySelector(strg);
        return titleElement ? titleElement.innerText : null;
      }, strg);
      // console.log(i, ": ", title);
      if (title != null) articles += title;
    }
    // const title = await page.evaluate(() => {
    //   const titleElement = document.querySelector(
    //     "#title > h1 > yt-formatted-string"
    //   );
    //   return titleElement ? titleElement.textContent.trim() : null;
    // });

    await browser.close();
    return articles;
  } catch (error) {
    console.log(error);
    return "";
  }
};

module.exports = { getYoutubeVideoTitle };

// getYoutubeVideoTitle(videoLink).then((title) => console.log("Content:", title));
