const puppeteer = require("puppeteer-extra");
const StealthPlugin = require("puppeteer-extra-plugin-stealth");

puppeteer.use(StealthPlugin());

const videoLink = "https://www.youtube.com/watch?v=EE2puUfCdLQ"; // 동영상 페이지 링크

const getYoutubeVideoTitle = async (videoLink) => {
  const browser = await puppeteer.launch({
    executablePath:
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome", // Chrome 실행 경로
    headless: false,
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  });

  const page = await browser.newPage();
  await page.setDefaultNavigationTimeout(60000);
  await page.goto(videoLink, { waitUntil: "networkidle2" });

  await page.waitForSelector("#attributed-snippet-text"); // 해당 요소가 로드될 때까지 기다립니다.

  const expandSelector = "#expand";
  try {
    await page.waitForSelector(expandSelector);
    // console.log("Button found, attempting to click...");
    await page.click(expandSelector);
    // console.log("Button clicked successfully.");
    await page.waitForSelector(
      "#description-inline-expander > yt-attributed-string > span > span:nth-child(4)"
    ); // 해당 요소가 로드될 때까지 기다립니다.
    await page.click(
      "#primary-button > ytd-button-renderer > yt-button-shape > button > yt-touch-feedback-shape > div > div.yt-spec-touch-feedback-shape__fill"
    );
    // console.log("Script clicked successfully.");
    await page.waitForSelector(
      "#segments-container > ytd-transcript-segment-renderer:nth-child(19) > div > yt-formatted-string"
    );
    // console.log("Finished Waiting");
  } catch (error) {
    console.error("Error in clicking the button:", error);
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
};

module.exports = { getYoutubeVideoTitle };

// getYoutubeVideoTitle(videoLink).then((title) => console.log("Content:", title));
