'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "321b3ffe657cd3e5f6452900088d7096",
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
"assets/assets/sounds/d10long.ogg": "3cb477fb09370efe05d66e7da3491532",
"assets/assets/sounds/d10Multiple.ogg": "550c103a5853bfb87a0446a0644d36c8",
"assets/assets/sounds/d10Single.ogg": "ad50103a8bf7ff381ee9d51e926fbad0",
"assets/assets/sounds/d10single_1.ogg": "09e8c21d02d0b6b24a22d1094defe99e",
"assets/assets/sounds/d10single_2.ogg": "635a8e7c85b1be0c7b3346e94a6a3c6c",
"assets/assets/sounds/d10single_3.ogg": "85c8d5e78bfb1f3c4f1a4777f75004e1",
"assets/assets/sounds/d12long.ogg": "1efd0a3a15556feb66687ad130d89e4d",
"assets/assets/sounds/d12Multiple.ogg": "4f9ed17194e76efba64625779531696c",
"assets/assets/sounds/d12Single.ogg": "00b0358d9ef2291c27111377a45a1c4c",
"assets/assets/sounds/d12single_1.ogg": "6cf5da6535fac31dd7a0826045675ee4",
"assets/assets/sounds/d12single_2.ogg": "2c186009b5cc19ee2d5c7f2ff1e9215e",
"assets/assets/sounds/d12single_3.ogg": "af7ee53b2776ff15ff08424612f2aac4",
"assets/assets/sounds/d20Big.ogg": "3f7dd4935787568efe94825d794dafbe",
"assets/assets/sounds/d20biglong.ogg": "cb4ebccaa8deca28ccdee3d0d94fbfec",
"assets/assets/sounds/d20Multiple.ogg": "575d352c9507c693ecd832891b1df1e6",
"assets/assets/sounds/d20single_2.ogg": "9596a7c64418bb8251217cfb5f32f1f5",
"assets/assets/sounds/d20Small.ogg": "851245b5bd3957e2a2f42f786f3be84f",
"assets/assets/sounds/d20smalllong.ogg": "65659761bdd5cf8cb225fe5316041844",
"assets/assets/sounds/d20small_1.ogg": "bc3b95b25c52b39e41f06edcdd628341",
"assets/assets/sounds/d4long.ogg": "2140b737740ee635034e3a0253f3c799",
"assets/assets/sounds/d4Multiple.ogg": "6d58c6230c4bac9b66442a166d34cc50",
"assets/assets/sounds/d4Single.ogg": "804ab4767bb5deefcf25d5fe7f871eb5",
"assets/assets/sounds/d4single_1.ogg": "adf2b6f90cbc6bdcfb62bf50310bec27",
"assets/assets/sounds/d4single_2.ogg": "f1c4e67061b2656d070ca9f4337ed2ba",
"assets/assets/sounds/d4single_3.ogg": "17c01ed670729dcd9c45738ba1f13387",
"assets/assets/sounds/d6long.ogg": "4919d114a8e9b549af090feb14232f00",
"assets/assets/sounds/d6Multiple.ogg": "9626f8582d701254832a8aee3d3bfcd6",
"assets/assets/sounds/d6Single.ogg": "e2edcc6120503810e655b82b55f948c9",
"assets/assets/sounds/d6single_1.ogg": "b586ece628a75377869deb685594e584",
"assets/assets/sounds/d6single_2.ogg": "7e5c4509f0c5dfd6b083ce26050a32a8",
"assets/assets/sounds/d6single_3.ogg": "496a32f32a17a324b585ae7ff840114d",
"assets/assets/sounds/d8long.ogg": "6f653b40a649e7990aa5b8f8e7a68726",
"assets/assets/sounds/d8Multiple.ogg": "fdae8bbdc2ae2da80e325f358db93b6f",
"assets/assets/sounds/d8Single.ogg": "e961792500910c109d67a6b5de8ae207",
"assets/assets/sounds/d8single_1.ogg": "a4b49db979052ccee3aac3b50a6961f2",
"assets/assets/sounds/d8single_2.ogg": "19901f852fc1c070c61b4c14e7bfb54d",
"assets/assets/sounds/d8single_3.ogg": "5fe05c390bd8f3bb0fbdd8937f4be6ef",
"assets/assets/sounds/oopfuck.ogg": "c096fc763885f4b2ee41c4258b162000",
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
"assets/LICENSE": "f449858201a3ac2579c75949607bfba0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "115e937bb829a890521f72d2e664b632",
"assets/sounds/d10long.ogg": "3cb477fb09370efe05d66e7da3491532",
"assets/sounds/d10Multiple.ogg": "550c103a5853bfb87a0446a0644d36c8",
"assets/sounds/d10Single.ogg": "ad50103a8bf7ff381ee9d51e926fbad0",
"assets/sounds/d10single_1.ogg": "09e8c21d02d0b6b24a22d1094defe99e",
"assets/sounds/d10single_2.ogg": "635a8e7c85b1be0c7b3346e94a6a3c6c",
"assets/sounds/d10single_3.ogg": "85c8d5e78bfb1f3c4f1a4777f75004e1",
"assets/sounds/d12long.ogg": "1efd0a3a15556feb66687ad130d89e4d",
"assets/sounds/d12Multiple.ogg": "4f9ed17194e76efba64625779531696c",
"assets/sounds/d12Single.ogg": "00b0358d9ef2291c27111377a45a1c4c",
"assets/sounds/d12single_1.ogg": "6cf5da6535fac31dd7a0826045675ee4",
"assets/sounds/d12single_2.ogg": "2c186009b5cc19ee2d5c7f2ff1e9215e",
"assets/sounds/d12single_3.ogg": "af7ee53b2776ff15ff08424612f2aac4",
"assets/sounds/d20Big.ogg": "3f7dd4935787568efe94825d794dafbe",
"assets/sounds/d20biglong.ogg": "cb4ebccaa8deca28ccdee3d0d94fbfec",
"assets/sounds/d20Multiple.ogg": "575d352c9507c693ecd832891b1df1e6",
"assets/sounds/d20single_2.ogg": "9596a7c64418bb8251217cfb5f32f1f5",
"assets/sounds/d20Small.ogg": "851245b5bd3957e2a2f42f786f3be84f",
"assets/sounds/d20smalllong.ogg": "65659761bdd5cf8cb225fe5316041844",
"assets/sounds/d20small_1.ogg": "bc3b95b25c52b39e41f06edcdd628341",
"assets/sounds/d4long.ogg": "2140b737740ee635034e3a0253f3c799",
"assets/sounds/d4Multiple.ogg": "6d58c6230c4bac9b66442a166d34cc50",
"assets/sounds/d4Single.ogg": "804ab4767bb5deefcf25d5fe7f871eb5",
"assets/sounds/d4single_1.ogg": "adf2b6f90cbc6bdcfb62bf50310bec27",
"assets/sounds/d4single_2.ogg": "f1c4e67061b2656d070ca9f4337ed2ba",
"assets/sounds/d4single_3.ogg": "17c01ed670729dcd9c45738ba1f13387",
"assets/sounds/d6long.ogg": "4919d114a8e9b549af090feb14232f00",
"assets/sounds/d6Multiple.ogg": "9626f8582d701254832a8aee3d3bfcd6",
"assets/sounds/d6Single.ogg": "e2edcc6120503810e655b82b55f948c9",
"assets/sounds/d6single_1.ogg": "b586ece628a75377869deb685594e584",
"assets/sounds/d6single_2.ogg": "7e5c4509f0c5dfd6b083ce26050a32a8",
"assets/sounds/d6single_3.ogg": "496a32f32a17a324b585ae7ff840114d",
"assets/sounds/d8long.ogg": "6f653b40a649e7990aa5b8f8e7a68726",
"assets/sounds/d8Multiple.ogg": "fdae8bbdc2ae2da80e325f358db93b6f",
"assets/sounds/d8Single.ogg": "e961792500910c109d67a6b5de8ae207",
"assets/sounds/d8single_1.ogg": "a4b49db979052ccee3aac3b50a6961f2",
"assets/sounds/d8single_2.ogg": "19901f852fc1c070c61b4c14e7bfb54d",
"assets/sounds/d8single_3.ogg": "5fe05c390bd8f3bb0fbdd8937f4be6ef",
"assets/sounds/oopfuck.ogg": "c096fc763885f4b2ee41c4258b162000",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "acfee861f06cdeb5f3d25d2655169aaa",
"/": "acfee861f06cdeb5f3d25d2655169aaa",
"main.dart.js": "75b1a2a4caf68dd2f39f887b3c9fd372",
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
