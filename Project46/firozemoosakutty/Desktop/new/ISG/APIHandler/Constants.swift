import Foundation

let kDuration = 0.15


// DFP content path
let kDFPContentPath = "http://rmcdn.2mdn.net/Demo/html5/output.mp4";

// Android content path
let kAndroidContentPath = "https://s0.2mdn.net/instream/videoplayer/media/android.mp4";

// Big buck bunny content path
let kBigBuckBunnyContentPath = "http://googleimadev-vh.akamaihd.net/i/big_buck_bunny/" +
    "bbb-,480p,720p,1080p,.mov.csmil/master.m3u8";

// Bip bop content path
let kBipBopContentPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";

// Standard pre-roll
let kPrerollTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&" +
    "correlator=";

// Skippable
let kSkippableTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=";

// Post-roll
let kPostrollTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vmap&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Ad rues
let kAdRulesTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Ad rules pods
let kAdRulesPodsTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
    "correlator=";

// VMAP pods
let kVMAPPodsTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vmap&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Wrapper
let kWrapperTag =
    "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator=";

// AdSense
let kAdSenseTag =
    "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video";

let IPAddressUrl = "http://freegeoip.net/json"
//let GetChannalApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Getvideo"
//let GetSearchResultsApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Searchvideo?"
//let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Searchlist"
//let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Similarvideo?"

let GetChannalApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Getvideo"
let GetSearchResultsApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Searchvideo?"
let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Searchlist?"
let GetMoreVideosUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Similarvideo?"
//let commonAPI = "https://poppo.tv/proxy/v2"
let commonAPI = "https://poppo.tv/platform/dev/"
//let commonAPI = "https://poppo.tv/proxy/"
let commonBkAPI = "https://poppo.tv/platform/bk/"

let thumbNailPath = "http://128.199.118.56/Testwrk/videoapp/uploads/thumbnail"
let videoPath = "http://128.199.118.56/Testwrk/videoapp/uploads/video"
let publisherImagePath = "http://128.199.118.56/Testwrk/videoapp/uploads/picture"
let getHomeApiUrl = commonBkAPI + "api/Home?"
let GetvideoList = commonBkAPI + "api/GetvideoList?"
let getHomePopularApiUrl = commonBkAPI + "api/PopularVideos?"
let GetAllChannels = commonBkAPI + "api/Getallchannels?"
let GetSimilarVideos = commonBkAPI + "api/Similarvideo?"
let GetSearchChannel = commonBkAPI + "api/Searchchannel?"
let GetHomeSearch = commonBkAPI + "api/SearchVideo?"
let RegisterApi = commonBkAPI + "Register"
let LoginApi = commonBkAPI + "Login?"
let FBloginApi = commonBkAPI + "FBLogin?"
let GetCategories = commonBkAPI + "api/GetCategories?"
let GetvideoByCategory = commonBkAPI + "api/GetvideoByCategory?"
let LikeVideo = commonBkAPI + "api/LikeVideo?"
let GetSearchVideo = commonBkAPI + "api/SearchVideo?"
let GetWatchlist = commonBkAPI + "api/GetWatchlist?"
let GetLanguages = commonBkAPI + "api/GetLanguages"
let SetLanguagePriority = commonBkAPI + "api/SetLanguagePriority?"
let GenerateToken = commonAPI + "api/GenerateToken?"
let UpdateWatchList = commonBkAPI + "api/updateWatchlist?"
let GetFeaturedVideos = commonBkAPI + "api/GetFeaturedvideo?"
let GetLocationAndIP = "https://extreme-ip-lookup.com/json"
let GetToken = commonBkAPI + "authenticate?"
let GetPopularChannelApiUrl = commonBkAPI + "api/PopularChannels?"
let ForgotpasswordApiUrl = commonBkAPI + "Forgotpassword?"
let GetDianamicHome = commonBkAPI + "GetHomeVideo?"
let GetUserLanguages = commonBkAPI + "api/GetUserLanguages?"
let GetAllLiveVideos = commonBkAPI + "api/GetAllLiveVideos?"
let GetShows = commonBkAPI + "api/getShows?"
let GetShowVideos = commonBkAPI + "api/getShowVideos?"
let GetGustUserLogin = commonBkAPI + "GuestRegister"
let LoginRemoval = commonBkAPI + "api/LoginRemoval"
let GetSelectedVideo = commonBkAPI + "api/GetSelectedVideo?"
let GetHomeChannelvideo = commonBkAPI + "api/Channelhome?"
let GenerateLiveToken = commonAPI + "api/GenerateTokenLive"
let getYoutubeVideo = commonBkAPI + "api/getYTVOD?"
let GetScheduleByDate = commonBkAPI + "api/getScheduleByDate?"
let GetUserSubscriptions = commonBkAPI + "api/getUserSubscriptions?"

let CheckPhoneVerification = commonBkAPI + "api/checkPhoneVerification?"
//let GetvideoSubscriptions = commonAPI + "api/GetvideoSubscriptions?"
//let GetchannelSubscriptions = commonAPI + "api/GetchannelSubscriptions?"

let GetvideoSubscriptions = commonBkAPI + "api/GetvideoSubscriptions?"
let GetchannelSubscriptions = commonBkAPI + "api/GetchannelSubscriptions?"

let VerifyPhoneNumber = commonBkAPI + "api/verifyPhoneNumber?"
let SubscriptionTransaction = commonBkAPI +  "api/UpdateTransaction?"
let GetPubID = commonBkAPI +  "getPubID?"


// Fonts
let FontRegular = "Montserrat-Regular"
let FontLight = "Montserrat-Light"
let FontBold = "Montserrat-Bold"
let FontExtraBold = "Montserrat-ExtraBold"
let FontBlack = "Montserrat-Black"
let FontExtraLight = "Montserrat-ExtraLight"
let FontMedium = "Montserrat-Medium"
let FontSemiBold = "Montserrat-SemiBold"
let FontThin = "Montserrat-Thin"

////image
// let imageUrl = "http://54.172.215.215/poppo_tv/thumbnails/"
//let channelUrl  = "http://54.172.215.215/poppo_tv/images/"
//let languageUrl  = "http://54.172.215.215/poppo_tv/language_icons/"
//let showUrl = "http://54.172.215.215/poppo_tv/show_logo/"

//image
let imageUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/thumbnails/"
let channelUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"
let languageUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/language_icons/"
let showUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/show_logo/"
let youtubeUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"

