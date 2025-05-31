const puppeteer = require('puppeteer');
const path = require('path');

(async () => {
  const browser = await puppeteer.launch({
    headless: 'new',
    defaultViewport: null
  });

  const page = await browser.newPage();

  // Capturar el banner
  await page.goto(`file:${path.join(__dirname, 'assets/images/banner.html')}`);
  await page.setViewport({ width: 1200, height: 300 });
  await page.waitForSelector('.container');
  await page.screenshot({
    path: 'assets/images/banner.jpg',
    quality: 100,
    type: 'jpeg'
  });

  // Capturar las características
  await page.goto(`file:${path.join(__dirname, 'assets/images/features.html')}`);
  await page.setViewport({ width: 1200, height: 500 });
  await page.waitForSelector('.container');
  await page.screenshot({
    path: 'assets/images/features.jpg',
    quality: 100,
    type: 'jpeg'
  });

  await browser.close();
})(); 