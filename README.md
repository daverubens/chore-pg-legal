# chore-pg-legal

Public legal and support pages for the **ChorePG** iOS app. This repo exists only to
give the App Store listing two working public URLs; the app's source lives in the
private `chore-pg` repo.

It is deliberately public — GitHub Pages only serves from public repos on the free
plan, and nothing here is private: a privacy policy and a support page are meant to
be world-readable.

## Pages

| File | Purpose |
|------|---------|
| `index.html` | Landing page. What the app is, links to the other two. |
| `privacy.html` | **Generated.** The privacy policy for the submitted release profile. |
| `support.html` | Support contact and common questions. Apple requires a Support URL. |

Published URLs once Pages is enabled:

- Home — `https://daverubens.github.io/chore-pg-legal/`
- Privacy Policy — `https://daverubens.github.io/chore-pg-legal/privacy.html`
- Support — `https://daverubens.github.io/chore-pg-legal/support.html`

The last two are the values for **Privacy Policy URL** and **Support URL** in
App Store Connect.

## Before enabling Pages

1. **Check the Google Group's settings.** Support mail goes to
   `rubenscube@googlegroups.com`. Two defaults will break it:
   - *Who can post* excludes outsiders by default, so mail from users bounces.
     Set it to allow anyone on the web, and moderate non-member posts for spam.
   - *View topics* (archive visibility) is public by default, which would publish
     support mail — including anything a parent writes about their family — on the
     open web. Restrict it to members.
2. Confirm `privacy.html` was generated from the profile you are actually submitting
   (see below). Its effective date is the date it was generated.

## Enabling Pages

Settings → Pages → Build and deployment → Source: **Deploy from a branch**, branch
`main`, folder `/ (root)`. First build takes a minute or two.

`.nojekyll` is present so Jekyll doesn't reinterpret anything.

## privacy.html is a build artifact — do not hand-edit it

The source of truth is `scripts/release-profile.mjs` in the app repo, which composes
the page from the selected release profile's feature flags. Public copy only describes
features present in that build, which is the point: the page cannot claim the app does
less (or more) than the binary actually does.

Hand-editing `privacy.html` here guarantees drift between the published page and the
shipped build. Change the generator instead, then re-sync.

To refresh, from the app repo:

```bash
node scripts/release-profile.mjs apply standalone-store
```

Then from this repo:

```bash
./sync-privacy.sh
```

The script takes an optional profile and app-repo path, defaulting to
`standalone-store` and `../chore-pg`. It applies one transform: the generated page
references the wordmark as `/assets/brand/...`, which is correct for the app's own web
root but 404s under a GitHub Pages subpath, so it is rewritten to a relative path. It
also re-copies the wordmark so the asset stays in step with the app's brand output.

## Re-sync whenever

- The submitted release profile changes (e.g. adding Drive sync → `drive-only-store`).
- The generator's privacy copy changes.
- A new version is submitted with a different feature set.

A profile change rewrites the whole page, so this is not optional housekeeping — the
published policy must match the build under review.

## Not included

No end-user licence agreement. Apple's standard Licensed Application End User License
Agreement applies by default unless a custom EULA is supplied in App Store Connect.
