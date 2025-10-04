import { test, expect } from '@playwright/test';

test('homepage loads successfully', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/E-Commerce/);
});

test('can navigate to products page', async ({ page }) => {
  await page.goto('/');
  await page.click('text=Products');
  await expect(page).toHaveURL(/.*products/);
});
