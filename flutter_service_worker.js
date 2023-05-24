'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/fonts/MaterialIcons-Regular.otf": "7a8e64535d3bc578a6938608ee5ba0c4",
"assets/NOTICES": "51b9e5edddca07c70f5f89546969631a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/packages/shuffle_uikit/assets/animations/lottie/shuffle-loader-1.json": "d8c84400ad9de7af9ddd5ae3f741e847",
"assets/packages/shuffle_uikit/assets/fonts/Unbounded-Medium.ttf": "55adb74779693d64f110681b2899380a",
"assets/packages/shuffle_uikit/assets/fonts/Unbounded-Light.ttf": "e78e751e037218f1d7e35f3a706b835a",
"assets/packages/shuffle_uikit/assets/fonts/Unbounded-SemiBold.ttf": "d47b0191eaa9dac534330da216500fe9",
"assets/packages/shuffle_uikit/assets/fonts/Unbounded-Regular.ttf": "bb28c00cd09ce2a42d68c78dfbf71b25",
"assets/packages/shuffle_uikit/assets/images/svg/analytics.svg": "be8aa90317c9b072daba2471b1a8a821",
"assets/packages/shuffle_uikit/assets/images/svg/Victory-hands.svg": "270801b53be462aee42594a532493e40",
"assets/packages/shuffle_uikit/assets/images/svg/star-outline.svg": "ffa823476e03d750b0bc86cade67649e",
"assets/packages/shuffle_uikit/assets/images/svg/like.svg": "4730afea8517f1a321fbd17108992deb",
"assets/packages/shuffle_uikit/assets/images/svg/armchair.svg": "4151cae0fb59c0fc694aa5f877183d5e",
"assets/packages/shuffle_uikit/assets/images/svg/Clapperboard.svg": "a36d7a8afda3ca96248107721b1bbdcc",
"assets/packages/shuffle_uikit/assets/images/svg/Networking.svg": "39a207e7bebcb8938b2f1a0223122045",
"assets/packages/shuffle_uikit/assets/images/svg/flag.svg": "38ba24d5bf7b42638a3912bc9c476161",
"assets/packages/shuffle_uikit/assets/images/svg/First-aid-kit.svg": "aaee74bd7bf023005540abfd5e8c9d30",
"assets/packages/shuffle_uikit/assets/images/svg/mask.svg": "cb2b44b7698e277f8358d19595f683ac",
"assets/packages/shuffle_uikit/assets/images/svg/exclamation.svg": "92f6dd4fa5be2fcd30be1bdbdd0354ef",
"assets/packages/shuffle_uikit/assets/images/svg/search-people.svg": "9d426c3557de6355d303d84743b7562d",
"assets/packages/shuffle_uikit/assets/images/svg/message.svg": "e46d6a3b1686c76fda423b446bc6fd41",
"assets/packages/shuffle_uikit/assets/images/svg/Laptop-with-chart.svg": "9b456ae5ae953df1ed1e54f07a537018",
"assets/packages/shuffle_uikit/assets/images/svg/Coin.svg": "31cf2fbec7cdcfe7ea808b0c3579f9bf",
"assets/packages/shuffle_uikit/assets/images/svg/Ok-hands.svg": "1d1432335895e8047b406644c876eae2",
"assets/packages/shuffle_uikit/assets/images/svg/building.svg": "81c5ec547b03c65d5ea83a3a41ce27d3",
"assets/packages/shuffle_uikit/assets/images/svg/Index-finger-hands.svg": "89bea09fe7379f9798751a2f240863e4",
"assets/packages/shuffle_uikit/assets/images/svg/heart-outline.svg": "084af6b3beea7cd0b62732161b497e82",
"assets/packages/shuffle_uikit/assets/images/svg/chevron-right.svg": "d48ddb05309140eceab45c4be1bd7c73",
"assets/packages/shuffle_uikit/assets/images/svg/chevron-up.svg": "a41cfbd2db65880fbe8638d0e5f2e821",
"assets/packages/shuffle_uikit/assets/images/svg/Sun-clouds.svg": "684aff3de45ba502bcb8187ece05250d",
"assets/packages/shuffle_uikit/assets/images/svg/shuffle_outline.svg": "67ad5477b2cb340b26c53a84235d8488",
"assets/packages/shuffle_uikit/assets/images/svg/Money.svg": "9938e5347629f2930eff8db33689d051",
"assets/packages/shuffle_uikit/assets/images/svg/Starry-eyed-excited-emoji.svg": "5e349aa3a9c86c11cc1e75052e78b9ce",
"assets/packages/shuffle_uikit/assets/images/svg/Technologies.svg": "d212634cd4a8b20ff69c2ae06910643a",
"assets/packages/shuffle_uikit/assets/images/svg/Hi-new-invitees.svg": "698e0c3b2aad6d955aa18433d5d3083d",
"assets/packages/shuffle_uikit/assets/images/svg/chevron-left.svg": "d5ff28fbfcbc7387920ec38a76e9de39",
"assets/packages/shuffle_uikit/assets/images/svg/Bell-notification.svg": "ff7f5c5e57eeaf8975698abddfcf9054",
"assets/packages/shuffle_uikit/assets/images/svg/calendar.svg": "ba60dae8b41ed98fd26d96e27ea9dc2f",
"assets/packages/shuffle_uikit/assets/images/svg/Smile-mood.svg": "31050d9084c8fc77f6d0e83ee8463eb9",
"assets/packages/shuffle_uikit/assets/images/svg/play-fill.svg": "f0531a58f573a136f097b5f485b547f5",
"assets/packages/shuffle_uikit/assets/images/svg/Giving-like-emoji.svg": "17da27fe6dec2498c471349fabde3449",
"assets/packages/shuffle_uikit/assets/images/svg/Binoculars.svg": "8835a40a17b26386dff43f80fdfa8413",
"assets/packages/shuffle_uikit/assets/images/svg/minus.svg": "ee5a45f8674bef83054e5a68fb0b0ed1",
"assets/packages/shuffle_uikit/assets/images/svg/spinner_fill.svg": "088f62fb868a278211fa7981ad600aba",
"assets/packages/shuffle_uikit/assets/images/svg/barcode.svg": "d506cb8aceb1247ef24b8c1409eef405",
"assets/packages/shuffle_uikit/assets/images/svg/Discount.svg": "c02394dd1fa6dbaf95b79f0d7e0b71b7",
"assets/packages/shuffle_uikit/assets/images/svg/hand-shake.svg": "14eae8d3e687202d75e7029dfdb3afe4",
"assets/packages/shuffle_uikit/assets/images/svg/trash.svg": "d13156653e650c278a272fd90f7c4992",
"assets/packages/shuffle_uikit/assets/images/svg/Laughing-with-tears-emoji.svg": "ab87ce686cee13584ca0476ae939a717",
"assets/packages/shuffle_uikit/assets/images/svg/Pie-chart.svg": "8846169e162cbb0f615387f9a9723dbf",
"assets/packages/shuffle_uikit/assets/images/svg/pencil.svg": "6aad524cad31a273310b4b22f0e5a495",
"assets/packages/shuffle_uikit/assets/images/svg/docs-fill.svg": "c70b66c2a86d05f3e8366230f2eafa10",
"assets/packages/shuffle_uikit/assets/images/svg/Donations.svg": "6f45245b2ac33225c6392bf04630ec74",
"assets/packages/shuffle_uikit/assets/images/svg/Followers.svg": "705f80ae14a68504dd098ba95b9c9578",
"assets/packages/shuffle_uikit/assets/images/svg/home_fill.svg": "b4085ee09a1a946b41c59ff0de191d01",
"assets/packages/shuffle_uikit/assets/images/svg/Dart.svg": "6f03a9e06dfc8d204944d2450473eff6",
"assets/packages/shuffle_uikit/assets/images/svg/landmark.svg": "f8b761ef1a739574eb3d5fe1c3f10ead",
"assets/packages/shuffle_uikit/assets/images/svg/route.svg": "db4acd663ecb5f09ac46d09e4f325e82",
"assets/packages/shuffle_uikit/assets/images/svg/star-2.svg": "c65cb40ff9b906549425fdf17f535f0d",
"assets/packages/shuffle_uikit/assets/images/svg/logo.svg": "dc028fad2ba8e5e0972ffc032a125523",
"assets/packages/shuffle_uikit/assets/images/svg/send.svg": "0a3390eaea611aaad6fa5845be40e1dc",
"assets/packages/shuffle_uikit/assets/images/svg/clock.svg": "5e7991ecf9469d31e784eb16de64bc8f",
"assets/packages/shuffle_uikit/assets/images/svg/settings-fill.svg": "31ca27c7f3247980ca4634ac50dccc21",
"assets/packages/shuffle_uikit/assets/images/svg/Male.svg": "0fd5fb1fff72a7632d3172df9e7080b1",
"assets/packages/shuffle_uikit/assets/images/svg/Ski.svg": "b5302cdd070b401da0a5bc3c86800d16",
"assets/packages/shuffle_uikit/assets/images/svg/user.svg": "d7e9b0fbe8e77b33cbdd0104cd2fc579",
"assets/packages/shuffle_uikit/assets/images/svg/shuffle_fill.svg": "3f24bfeba5ddad044fc75945c04096b4",
"assets/packages/shuffle_uikit/assets/images/svg/dice.svg": "23693db9ab3b00e5622ec6e4b06a736c",
"assets/packages/shuffle_uikit/assets/images/svg/bell.svg": "52bcbf849358856b4599918a09e69491",
"assets/packages/shuffle_uikit/assets/images/svg/arrow-left.svg": "a7231dd6bae5e689da3de61a8a35c3e8",
"assets/packages/shuffle_uikit/assets/images/svg/bath.svg": "cba7cb8d7446402556de41b65665af1b",
"assets/packages/shuffle_uikit/assets/images/svg/label.svg": "e87cb90f6107fcd48a736249f7a0b23b",
"assets/packages/shuffle_uikit/assets/images/svg/search_fill.svg": "42addc56ec866fdaff81307e341441b2",
"assets/packages/shuffle_uikit/assets/images/svg/cocktail.svg": "ba8b564095b9a633a258c25cba4c6915",
"assets/packages/shuffle_uikit/assets/images/svg/analytics-fill.svg": "1e695d9a8138759212f69c62db9deea5",
"assets/packages/shuffle_uikit/assets/images/svg/dollar.svg": "1d9dc011cb2152d2796122e18552a4d1",
"assets/packages/shuffle_uikit/assets/images/svg/settings-outline.svg": "67e5448f6a60c40b2972c643f6ee6d0c",
"assets/packages/shuffle_uikit/assets/images/svg/trend-down.svg": "d0d1d6a62721336d868432e13732786b",
"assets/packages/shuffle_uikit/assets/images/svg/archive.svg": "1a37ccd29e696307dcf2a2f675cbba94",
"assets/packages/shuffle_uikit/assets/images/svg/Like-hands.svg": "4f2828152b45a1d8d1088e650a15283c",
"assets/packages/shuffle_uikit/assets/images/svg/Hat.svg": "521e342b358c6f850ddfe667cc558131",
"assets/packages/shuffle_uikit/assets/images/svg/Smiley-crazy-face-emoji.svg": "8a114ddc39da795246ac6a842a680157",
"assets/packages/shuffle_uikit/assets/images/svg/star-fill.svg": "91d5883cdd4c32ac61d4568864c9a606",
"assets/packages/shuffle_uikit/assets/images/svg/Rockandroll-hands.svg": "af6893af187efed40581b2c460521bd5",
"assets/packages/shuffle_uikit/assets/images/svg/premium_account_mark.svg": "e8ed7d52a6914035baff81f7f7d4d94f",
"assets/packages/shuffle_uikit/assets/images/svg/loader.svg": "fbca1ff68301b487bf9d8198a6d8fa10",
"assets/packages/shuffle_uikit/assets/images/svg/Femle.svg": "72276685c4c754821e11068afb44b4c2",
"assets/packages/shuffle_uikit/assets/images/svg/Company.svg": "089a1434058f9192d17f8733717ec348",
"assets/packages/shuffle_uikit/assets/images/svg/thumb-up.svg": "6e3992d271e7a62ef64d30b1bdced226",
"assets/packages/shuffle_uikit/assets/images/svg/x.svg": "83ab634bac03dfaedcb12a287d03cb21",
"assets/packages/shuffle_uikit/assets/images/svg/Key.svg": "f726eae20a6cf8f0a57b3f2363873163",
"assets/packages/shuffle_uikit/assets/images/svg/cutlery.svg": "bee4dea4ca223f0dfb7af14ffcce50ba",
"assets/packages/shuffle_uikit/assets/images/svg/Other-gender.svg": "0c71d1fcbc8b08b6a36517aece66c473",
"assets/packages/shuffle_uikit/assets/images/svg/influencer_account_mark.svg": "d89b43a0db133af43e61a6a899f39686",
"assets/packages/shuffle_uikit/assets/images/svg/wallet.svg": "e83800ebe86169f1f35455fb528c35be",
"assets/packages/shuffle_uikit/assets/images/svg/tripple_arrow_black.svg": "b73f1087bfcde3dda819809e9fb06377",
"assets/packages/shuffle_uikit/assets/images/svg/profile-plus.svg": "67ec6f47dc22a4e220a65ac7f1af38c6",
"assets/packages/shuffle_uikit/assets/images/svg/Icecream.svg": "40b0ec9631afe088371cf1ffdcda597d",
"assets/packages/shuffle_uikit/assets/images/svg/spinner_wheel.svg": "4ff5a1ef0acc39566591ff95a996e806",
"assets/packages/shuffle_uikit/assets/images/svg/Map.svg": "ccbc4bfc15263c340136cce31aafa204",
"assets/packages/shuffle_uikit/assets/images/svg/info.svg": "c3f4a3c7a32eb099aa64eab59d56612c",
"assets/packages/shuffle_uikit/assets/images/svg/search.svg": "17e0d728ccb3111998b7179a3f19a844",
"assets/packages/shuffle_uikit/assets/images/svg/camera-plus.svg": "cfce0cafa8444a3697ce756d3e9d3205",
"assets/packages/shuffle_uikit/assets/images/svg/heart-broken-fill.svg": "19f9b9caea932ce917f563db7ca04fcc",
"assets/packages/shuffle_uikit/assets/images/svg/chevron-up-long.svg": "e4a3c3dae5a4c1bbe80556e506e5d19d",
"assets/packages/shuffle_uikit/assets/images/svg/Mango.svg": "90581088bbce688abf4a4964d932c42e",
"assets/packages/shuffle_uikit/assets/images/svg/trend-up.svg": "9283b5b92db0e76a9db924c3f39fc47a",
"assets/packages/shuffle_uikit/assets/images/svg/keyboard.svg": "e423d230e0677662a14fc8140d677809",
"assets/packages/shuffle_uikit/assets/images/svg/profile_outline.svg": "18e0e32803581afd993f55cbd9b5a596",
"assets/packages/shuffle_uikit/assets/images/svg/pro_account_mark.svg": "74290d06de478f1211bc4f67884957b0",
"assets/packages/shuffle_uikit/assets/images/svg/settings.svg": "4426f433653ee09f88d4db7d0c407d45",
"assets/packages/shuffle_uikit/assets/images/svg/pause.svg": "df340f1f202ecf20a324a8ba41ef6eeb",
"assets/packages/shuffle_uikit/assets/images/svg/Sun-wind.svg": "8893a31a47df2a845d5a5e027e7b1a31",
"assets/packages/shuffle_uikit/assets/images/svg/star.svg": "d8d6fb15311d965839e0eb4b54b170ac",
"assets/packages/shuffle_uikit/assets/images/svg/Smile-in-mask-emoji.svg": "16eb52a7c060e687983323c6adf2e170",
"assets/packages/shuffle_uikit/assets/images/svg/video-plus.svg": "f13ea04a5da38011432720c61da3963d",
"assets/packages/shuffle_uikit/assets/images/svg/Baggage.svg": "a93de3c696211a0c65e6706c0c99f111",
"assets/packages/shuffle_uikit/assets/images/svg/Pixelated-sunglasses-emoji.svg": "774bf3a2f6920dfe8028378e697abe04",
"assets/packages/shuffle_uikit/assets/images/svg/Events.svg": "4b7ba6e401bcbd9668a6cdd26e93d278",
"assets/packages/shuffle_uikit/assets/images/svg/play_arrow.svg": "ae8539c4674169651d1e56c9931f735b",
"assets/packages/shuffle_uikit/assets/images/svg/Aubergine.svg": "48fa1d780c6df6f4d42520adc97fa006",
"assets/packages/shuffle_uikit/assets/images/svg/music.svg": "ddc733516e3d0e37b3ecbd201190cd5f",
"assets/packages/shuffle_uikit/assets/images/svg/check.svg": "d12b4bce4697bc6309ca7a30391a4b92",
"assets/packages/shuffle_uikit/assets/images/svg/hookah.svg": "961849b1dbeae6ae7e1de8c328e1ce9f",
"assets/packages/shuffle_uikit/assets/images/svg/Rocket.svg": "310bb27bf32fc5f31d7ba9ce2b297ddd",
"assets/packages/shuffle_uikit/assets/images/svg/play.svg": "82424c09d68ae6f13457c068c2f98d6b",
"assets/packages/shuffle_uikit/assets/images/svg/chess.svg": "cc98afcb4845033adca84546eea19cae",
"assets/packages/shuffle_uikit/assets/images/svg/chevron-down.svg": "0e8a3b356111a03e41270d28c0376c7e",
"assets/packages/shuffle_uikit/assets/images/svg/docs-outline.svg": "c55c9dc2e0a45a4726d3ecd62438b285",
"assets/packages/shuffle_uikit/assets/images/svg/location.svg": "c6ae63b71cb70bcf5f2de4c663fed66d",
"assets/packages/shuffle_uikit/assets/images/svg/history.svg": "a329bda6e3ed3af025f4ec8c10c816d9",
"assets/packages/shuffle_uikit/assets/images/svg/lifebuoy.svg": "892a4542b470e22a24dc6c974995310f",
"assets/packages/shuffle_uikit/assets/images/svg/Cocktail-3d.svg": "d9a18e5a3f87237b97e6adfdc4102fd2",
"assets/packages/shuffle_uikit/assets/images/svg/analytics-outline.svg": "2e79f9969d6e9452a326530a9a24a471",
"assets/packages/shuffle_uikit/assets/images/svg/connection-outline.svg": "3a8950affccdfccccc5b1dc6f17bfcec",
"assets/packages/shuffle_uikit/assets/images/svg/profile_fill.svg": "d1007d762ec98c3bee5d58727e873f66",
"assets/packages/shuffle_uikit/assets/images/svg/more-vert.svg": "938097acabe33ab519a6110de169bcc2",
"assets/packages/shuffle_uikit/assets/images/svg/Puzzle.svg": "65c49180283addb06d7f25629d46afa8",
"assets/packages/shuffle_uikit/assets/images/svg/white_star.svg": "5a6b30b6a4249a45cb52cfa6b69b42f5",
"assets/packages/shuffle_uikit/assets/images/svg/Training-apparatus.svg": "0829a57fa2478cb063fa54fbfd4e306f",
"assets/packages/shuffle_uikit/assets/images/svg/connection-fill.svg": "92f40f009d9a78b9e4d9c07cea7f7d5d",
"assets/packages/shuffle_uikit/assets/images/svg/water.svg": "e2a9cb48863e78a7003c3792f8670d52",
"assets/packages/shuffle_uikit/assets/images/svg/warning.svg": "a6c44d14d3baa097bd55c4b94284c57f",
"assets/packages/shuffle_uikit/assets/images/svg/diamond.svg": "940e90ce4c86a6ca603925d17f62df89",
"assets/packages/shuffle_uikit/assets/images/svg/Outstanding.svg": "2f5854005bfdb925bdea3cbd200a91a0",
"assets/packages/shuffle_uikit/assets/images/svg/rising_trend_icon.svg": "83c0a509991cdd825d20d299a9e3d279",
"assets/packages/shuffle_uikit/assets/images/svg/Cocktail-2.svg": "960f410dc85ec4a6e6620898d094c5fd",
"assets/packages/shuffle_uikit/assets/images/svg/Fire.svg": "981951643078102cc8065f17cb3afe41",
"assets/packages/shuffle_uikit/assets/images/svg/heart-fill.svg": "1b5842e9214f22013abb55618af1fef9",
"assets/packages/shuffle_uikit/assets/images/svg/plus.svg": "b93245de58bdad1b09565df3429834de",
"assets/packages/shuffle_uikit/assets/images/svg/files.svg": "9e5404147c0e9a5c7c518e67c7e86b01",
"assets/packages/shuffle_uikit/assets/images/svg/stop.svg": "022995e077542524cc2767e5c558463e",
"assets/packages/shuffle_uikit/assets/images/svg/scan.svg": "babbd2c597d515817e6aecce9bcedad1",
"assets/packages/shuffle_uikit/assets/images/svg/Heart-in-hand-emoji.svg": "d7d64b5b87383e5fe1a02dd53f992d63",
"assets/packages/shuffle_uikit/assets/images/svg/triple_arrow.svg": "a20eaac4886fab916549ac4271f4b8e7",
"assets/packages/shuffle_uikit/assets/images/svg/sufle.svg": "0ceef844db9713f0f870b54d22d9a27e",
"assets/packages/shuffle_uikit/assets/images/svg/Feedback.svg": "df05a64b7d69fc2b6819090e8ce457a4",
"assets/packages/shuffle_uikit/assets/images/svg/fire_white.svg": "dcffa69e555f17e4caa6b9eb4552e8f2",
"assets/packages/shuffle_uikit/assets/images/svg/Grinning-face-with-sweat-emoji.svg": "3e6de6a8337984a235c522eb12d1197d",
"assets/packages/shuffle_uikit/assets/images/svg/search_outline.svg": "32c937dc1e32db510f890c8e52aac075",
"assets/packages/shuffle_uikit/assets/images/svg/Yoga.svg": "3734d10701842716d9d46f082dee7170",
"assets/packages/shuffle_uikit/assets/images/svg/Porthole.svg": "e7b70d4cc41dd9d0a3ad0a361843f347",
"assets/packages/shuffle_uikit/assets/images/svg/question.svg": "ece032f6c038befa4f0dadcab5ca6df1",
"assets/packages/shuffle_uikit/assets/images/svg/Angry-emoji.svg": "4e07531b04bd1c482631ee9436e5b0dc",
"assets/packages/shuffle_uikit/assets/images/svg/spinner_outline.svg": "0145b2f712b6af75809b3f7de78bcc25",
"assets/packages/shuffle_uikit/assets/images/svg/Lifebuoy-3d.svg": "081634c6feea826ca18ba041fa369a4c",
"assets/packages/shuffle_uikit/assets/images/svg/home_outline.svg": "a75a9944c8c869219686c425eff1740b",
"assets/packages/shuffle_uikit/assets/images/svg/Heart-eyes-emoji.svg": "8ea6e5ec9799419d727522141735bdd0",
"assets/packages/shuffle_uikit/assets/images/svg/logout.svg": "57903dcaf463338eb5596b352ea0c94d",
"assets/packages/shuffle_uikit/assets/images/png/event_avatar.png": "b7ef1464c2a65494b4b59de99523dd8b",
"assets/packages/shuffle_uikit/assets/images/png/atmosphere.png": "2262e65620263e3787c97dff1631370f",
"assets/packages/shuffle_uikit/assets/images/png/balloons.png": "7ddb74a4d9ad87f68d1a315042f7d170",
"assets/packages/shuffle_uikit/assets/images/png/profile_post_1.png": "ccbf3bbab9d37c20b72f45ecb40e45e6",
"assets/packages/shuffle_uikit/assets/images/png/profile_story_1.png": "b6771b7db36ed5927964c3ac558279f7",
"assets/packages/shuffle_uikit/assets/images/png/profile_avatar.png": "827f8c0cca8abe806362de525120c2c1",
"assets/packages/shuffle_uikit/assets/images/png/mock_swiper_card.png": "67a1d4da6b5cb33dd100edec89fa7cf2",
"assets/packages/shuffle_uikit/assets/images/png/mock_user_avatar.png": "c0d2a5956b579e4191d04c75059bbd14",
"assets/packages/shuffle_uikit/assets/images/png/place.png": "7df799ddc657f3d3fc364f0635ffe38b",
"assets/packages/shuffle_uikit/assets/images/png/spinner_event.png": "28986e0ca74e1819a26f87827ed6ed62",
"assets/packages/shuffle_uikit/assets/images/png/mock_ad_banner.png": "60bed0db2fecc5015ccfd409370373d4",
"assets/FontManifest.json": "294fdfe73b8743b3bf3ec1c84c310d8c",
"assets/AssetManifest.json": "e78171a559de899473443e665c650873",
"assets/AssetManifest.smcbin": "45e952e3dda1a3d322ee16c9de7f7525",
"index.html": "1e99fee4114e198a898a31629f90d523",
"/": "1e99fee4114e198a898a31629f90d523",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "ff966ab969ba381b900e61629bfb9789",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"main.dart.js": "b20bf126e7335ab21b8a8a2f0c18b190",
"manifest.json": "0867c3e13649ac4d06fe34b7b3ddce08"};
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
