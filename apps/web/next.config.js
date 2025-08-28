/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: ['@bpo-financeiro/shared', '@bpo-financeiro/ui'],
}

module.exports = nextConfig