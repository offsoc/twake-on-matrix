'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/assets/backup.png": "9c1f3ddbb59cee5be2c72ae4eabead1e",
"assets/assets/typing.svg": "fac23aaad793ddae0aae89dc7f8bd843",
"assets/assets/login_wallpaper.png": "510b5aa8e16b4e0e29fd0878b3d4b5ce",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/WoodenBeaver_stereo_message-new-instant.ogg": "88fb9823caeb64edffd343530fae9e8b",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.svg": "207438e20822f9febafe560518717137",
"assets/assets/twake_dark.svg": "c42ebcd46a1422c98d2b3b213051b117",
"assets/assets/verification.png": "cfafe6d01ed9f2b08312157bc2fd36d3",
"assets/assets/twake_light.svg": "c2116afd8c0f62ccaf3c2be991ebe502",
"assets/assets/info-logo.svg": "ccabf48173356d141e75117a97217944",
"assets/assets/chat.svg": "eedd029d2f9f923ffbc09aeb5cf9b1f2",
"assets/assets/js/package/package.json": "839b246543460d87ef3daa4ddfb55d36",
"assets/assets/js/package/olm.wasm": "d961f40073b95e31b9ae351fb613e5e3",
"assets/assets/js/package/README.md": "25435e90088777d41d6cf1e6656a983f",
"assets/assets/js/package/olm.js": "8e2b7fdbf7ee9961fb5c1bad82040f16",
"assets/assets/js/package/olm_legacy.js": "d4bc663681c32ea3f06ba04a2336a83e",
"assets/assets/js/package/checksums.txt": "5a2f32df1ec11ca84e8a7b241c9ef3ee",
"assets/assets/js/package/index.d.ts": "6f7f68b7e5fc2beea17277325838ce1c",
"assets/assets/typing.gif": "c64522db9f8f84611d53b0e4ba5fee4e",
"assets/assets/images/ic_add_file.svg": "9859cc119524e16762d3b224edf2263b",
"assets/assets/images/ic_keyboard.svg": "f645fdb3b8b5bf6855bd31c8887dbdfe",
"assets/assets/images/ic_video_call.svg": "6db2a0b890a0a21a69eb2e060acdcbcf",
"assets/assets/images/ic_emoji.svg": "1b11eb24e54a7de168a66a5a5b6f6582",
"assets/assets/images/ic_sending.svg": "df9516e5b59e9acf28ed66ae866b34a2",
"assets/assets/images/ic_empty_group_chat.svg": "a18dafc1c0b26ece5b535b7e0fe938f1",
"assets/assets/images/ic_file_pdf.svg": "d787b97477b7b5a0103357986f58ca7d",
"assets/assets/images/ic_skeletons.svg": "488593cfb472afd1c0d9deca5044cc17",
"assets/assets/images/ic_file_folder.svg": "d6faf704931af9ae15f56e9799b884d0",
"assets/assets/images/ic_add.svg": "d58d0790c9e5f56accb3a5ed2e302e0e",
"assets/assets/images/ic_send_status.svg": "3df8e86571574fbe25a89d96dd8c7b2f",
"assets/assets/images/ic_application_grid.svg": "daca5ee3e103d31cb07f0de654c76a96",
"assets/assets/images/ic_file_unknow.svg": "fab639d1f8944c7ae02fc4485ec22021",
"assets/assets/images/ic_voice_message.svg": "940ee378e90db3d7a4063edf96f1822d",
"assets/assets/images/ic_twake_image_logo.svg": "e55a0faf67b3c8ff1070acbfd156d1a9",
"assets/assets/images/ic_photos_setting.svg": "9d75d8f97f598db5c574115f5d13ba4c",
"assets/assets/images/ic_send.svg": "e12c7083ba78fde87e94fa7c770d2bfb",
"assets/assets/images/ic_file_excel.svg": "3ed3b9438506d99d551ec0cf1fab5198",
"assets/assets/images/ic_done.svg": "dcb4de20a0adbea1d72c3f9a09cad618",
"assets/assets/images/ic_file_doc.svg": "040b4b2fd2a9600946248c730343cd50",
"assets/assets/images/ic_users_outline.svg": "25351812a5e56c56fc4fb374c6eade79",
"assets/assets/images/ic_file_zip.svg": "630590a282a50589e8010f36fa7b8f0e",
"assets/assets/images/ic_phone_call.svg": "42e78388f9998f29587e2b0225f93a9b",
"assets/assets/images/ic_twake_logo.svg": "800c29b7c5635b493f896268e233d3ff",
"assets/assets/images/ic_status.svg": "7c8a5e293525eab892cacb5d2adbea6e",
"assets/assets/images/ic_file_ppt.svg": "189bfb711df660cf307ab18a29b4a8a4",
"assets/assets/share.png": "6d8b7e3179bea3d8b7ea1287594289bd",
"assets/assets/favicon.ico": "58c583a47977a32782a8706d5a84533c",
"assets/assets/favicon.png": "57c9c7d1d2d506e3beeb242fa2e2d5f8",
"assets/assets/branding.png": "91040b80ee5fa19af22d2312bf9050d8",
"assets/assets/typing-indicator.zip": "48796aa5159cb9ac3f6381ba7abfa405",
"assets/assets/info-logo.png": "a32bff2f9b9673573bb0d3ad4aa6a9f7",
"assets/assets/start_chat.png": "5f236310a0ac655505862b9d6a11056a",
"assets/assets/twake.svg": "1400440527b8b4c4beddfa3cd0f91351",
"assets/assets/icons/icon_launcher.png": "95c80ff5f0bbcd846130c05ac2882f12",
"assets/assets/logo.png": "57c9c7d1d2d506e3beeb242fa2e2d5f8",
"assets/assets/colors.png": "fde0db0023d9fc4b7c96a8114e9329bb",
"assets/assets/banner_dark.png": "6310493efdf749239c991ec8cf2ac366",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/encryption.png": "85367d8a3630d5791124f10a63e7f9d1",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/blur.png": "c9fbc0645941a7124459e5abf9974042",
"assets/fonts/NotoEmoji/NotoColorEmoji.ttf": "ed84f46d3d5564a08541cd64bddd495c",
"assets/fonts/Roboto/Roboto-Italic.ttf": "465d1affcd03e9c6096f3313a47e0bf5",
"assets/fonts/Roboto/Roboto-Bold.ttf": "9ece5b48963bbc96309220952cda38aa",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Regular.ttf": "f36638c2135b71e5a623dca52b611173",
"assets/fonts/MaterialIcons-Regular.otf": "b00ba8d64b0c2d06d1d785875d7a4017",
"assets/fonts/Inter/Inter-SemiBold.ttf": "1753a05196abeef95c32f10246bd6473",
"assets/fonts/Inter/Inter-ExtraLight.ttf": "c36ac5a28afa9a4d70292df06a932ccd",
"assets/fonts/Inter/Inter-Bold.ttf": "d17c0274915408cee0308d5476df9f45",
"assets/fonts/Inter/Inter-Regular.ttf": "a4a7379505cd554ea9523594b7c28b2a",
"assets/fonts/Inter/Inter-Thin.ttf": "be37c2ebe9cd2e0719d1a9437858686f",
"assets/fonts/Inter/Inter-Medium.ttf": "16580ed788273749548eb27b9a9b674f",
"assets/fonts/Inter/Inter-Light.ttf": "60c8f64064078554b6469eeda25944eb",
"assets/fonts/Inter/Inter-Black.ttf": "10215142a203211d9292c62ae0503a97",
"assets/fonts/Inter/Inter-ExtraBold.ttf": "e771faf703386b0c5863cc3df1e26ba1",
"assets/AssetManifest.json": "9db2d90ba4bc89665eacbc2bc5e66639",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "699aa2e43adff25d0be51f7f427c15f5",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "a6cefffbf9eccd63a12e4d9535660e70",
"assets/FontManifest.json": "b7b0a59c6c75a3b1ab32504828749613",
"assets/NOTICES": "e249cb8d005ad23062dedd86c76836cd",
"auth.html": "aaf3b82bee208cb193342ff1c7252919",
"splash/style.css": "4d1f54fea6fddad3e588e47e3fa65268",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/img/branding-dark-2x.png": "28e86c4a86611f89fbea4b2239323655",
"splash/img/dark-3x.png": "d7a83f22fdee6d2fca454982d55aa469",
"splash/img/dark-2x.png": "26f05b769dc261a6536fdb257fdb1883",
"splash/img/light-1x.png": "2ea9fd1216889717edb83a0c3f4c2a2f",
"splash/img/branding-1x.png": "2063bc3bb018dc3679fa741c6111ae3e",
"splash/img/branding-4x.png": "be79b42cdc9510f8b72deb26f22af985",
"splash/img/dark-1x.png": "2ea9fd1216889717edb83a0c3f4c2a2f",
"splash/img/light-4x.png": "fffeb59f73f4bf59eba563c9f9127cc8",
"splash/img/branding-3x.png": "a8f173d5d7f1f15be6a3f8cb4f00a9bd",
"splash/img/branding-dark-3x.png": "a8f173d5d7f1f15be6a3f8cb4f00a9bd",
"splash/img/branding-dark-4x.png": "be79b42cdc9510f8b72deb26f22af985",
"splash/img/branding-2x.png": "28e86c4a86611f89fbea4b2239323655",
"splash/img/light-2x.png": "26f05b769dc261a6536fdb257fdb1883",
"splash/img/branding-dark-1x.png": "2063bc3bb018dc3679fa741c6111ae3e",
"splash/img/dark-4x.png": "fffeb59f73f4bf59eba563c9f9127cc8",
"splash/img/light-3x.png": "d7a83f22fdee6d2fca454982d55aa469",
"version.json": "8223b23d5e3963923a5aaa2c0d6af783",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"index.html": "280c1db2c99b87a02388e0507e60ccde",
"/": "280c1db2c99b87a02388e0507e60ccde",
"favicon.png": "d6fd96e2d81a9853d4b0870fec11d291",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"icons/Icon-192.png": "a82dc9b187a5d459bf9798775c6951a1",
"icons/Icon-512.png": "7b09d20196b22a97624ab12900f85da3",
"main.dart.js": "67d83269400829dc99393dd3d702096e",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
