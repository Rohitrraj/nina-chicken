# kedai_ayam_nina

A new Flutter project.

<!-- stage6-vercel-deployment -->
## Production Deployment

The Flutter web application and the Cloudinary serverless endpoints are deployed
together on Vercel.

### Build

```bash
bash scripts/vercel-build.sh
```

The generated static application is written to `build/web`. When
`APP_API_BASE_URL` is not provided, the Flutter client uses the current website
origin for `/api/cloudinary-signature` and `/api/cloudinary-delete`.

### Required Vercel environment variables

Configure these values for Production and Preview in Vercel Project Settings:

- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`
- `FIREBASE_SERVICE_ACCOUNT_BASE64`

Do not expose these values in Flutter client code or commit local environment
files.

### Production validation

```bash
bash scripts/validate-production.sh https://your-project.vercel.app
```

After the automated HTTP checks pass, validate login, Firestore product and
transaction operations, Cloudinary image upload and cleanup, browser console
output, responsive layouts, and direct route refreshes.
