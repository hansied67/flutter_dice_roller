'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "9a32bc20f1692f4ead3b312958b99999",
"assets/assets/dice_images/d10.png": "9a2e157881a98256904c56a87df02590",
"assets/assets/dice_images/d100.png": "2f9c1c3dca85ca0725c5326889bc4ed8",
"assets/assets/dice_images/d12.png": "283edbd05a914ffb1435939b341b8351",
"assets/assets/dice_images/d2.png": "47aa39a82ba078571f029517122e0e02",
"assets/assets/dice_images/d20.png": "3f3cfaa19024aa8aded4d9bd475480fe",
"assets/assets/dice_images/d2_blank.png": "9a231aafaccb9c0587b22430d28890fb",
"assets/assets/dice_images/d4.png": "995f52dd203c88bbd31053ef134fb55c",
"assets/assets/dice_images/d6.png": "6ae50bea6c03a39bfc2a988d1bd00db5",
"assets/assets/dice_images/d8.png": "aa4d8fce5463b394151accf1f4d57d4c",
"assets/assets/docs/custom_roll.txt": "c81e728d9d4c2f636f067f89cc14862c",
"assets/assets/icon/icon.png": "b8523f99d00d427da2ddeae2b2d03883",
"assets/assets/icon/icon_background.png": "48ac7bda7a2fce7ed0e74a9a1545fdd9",
"assets/assets/sounds/d10long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d10Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d10Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d10single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d10single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d10single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d12single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20Big.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20biglong.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20Small.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20smalllong.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d20small_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d4single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d6single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/d8single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/sounds/oopfuck.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/dice_images/d10.png": "9a2e157881a98256904c56a87df02590",
"assets/dice_images/d100.png": "2f9c1c3dca85ca0725c5326889bc4ed8",
"assets/dice_images/d12.png": "283edbd05a914ffb1435939b341b8351",
"assets/dice_images/d2.png": "47aa39a82ba078571f029517122e0e02",
"assets/dice_images/d20.png": "3f3cfaa19024aa8aded4d9bd475480fe",
"assets/dice_images/d2_blank.png": "9a231aafaccb9c0587b22430d28890fb",
"assets/dice_images/d4.png": "995f52dd203c88bbd31053ef134fb55c",
"assets/dice_images/d6.png": "6ae50bea6c03a39bfc2a988d1bd00db5",
"assets/dice_images/d8.png": "aa4d8fce5463b394151accf1f4d57d4c",
"assets/docs/custom_roll.txt": "c81e728d9d4c2f636f067f89cc14862c",
"assets/FontManifest.json": "01700ba55b08a6141f33e168c4a6c22f",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/LICENSE": "7b717ffdc9b012eed1de45e3ae775aaf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/sounds/d10long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d10Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d10Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d10single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d10single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d10single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d12single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20Big.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20biglong.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20Small.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20smalllong.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d20small_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d4single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d6single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8long.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8Multiple.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8Single.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8single_1.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8single_2.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/d8single_3.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/sounds/oopfuck.ogg": "d41d8cd98f00b204e9800998ecf8427e",
"favicon.png": "8bd74578db75f4ee0d142c9497e6038b",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "acfee861f06cdeb5f3d25d2655169aaa",
"/": "acfee861f06cdeb5f3d25d2655169aaa",
"main.dart.js": "e66fbbf0d1caa2399d252a40504ce52e",
"manifest.json": "a066eb180276910134e0e4f5188aedf6"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
