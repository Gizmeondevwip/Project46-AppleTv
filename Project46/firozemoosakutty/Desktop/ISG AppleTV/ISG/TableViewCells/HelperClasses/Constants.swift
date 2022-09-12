import Foundation

let kDuration = 0.15


// DFP content path
let kDFPContentPath = "http://rmcdn.2mdn.net/Demo/html5/output.mp4";

// Android /Users/firozemoosakutty/Desktop/TVExcelApp/TVExcel/Constants.swiftcontent path
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
let commonAPI = "https://poppo.tv/proxy/"
//let commonAPI = "https://poppo.tv/proxy/"
let commonBkAPI = "https://api.gizmott.com/api/v1/"
//let commonBkAPI = "https://staging.poppo.tv/api/v1/"

let thumbNailPath = "http://128.199.118.56/Testwrk/videoapp/uploads/thumbnail"
let videoPath = "http://128.199.118.56/Testwrk/videoapp/uploads/video"
let publisherImagePath = "http://128.199.118.56/Testwrk/videoapp/uploads/picture"
//let RegisterApi = commonBkAPI + "Register"
let LoginApi = commonBkAPI + "account/login?"
let GetThemes = commonBkAPI + "api/GetThemes?"
let GetToken = commonBkAPI + "account/authenticate?"
let ForgotpasswordApiUrl = commonBkAPI + "account/passwordReset?"
let GetSearchVideo = commonBkAPI + "search/shows?"
let GetSearchSuggestionVideo = commonBkAPI + "search/suggestions?"
let GetUserSubscriptions = commonBkAPI + "subscription/user?"
let partnerList = commonBkAPI + "partner/list"
let GetAllChannels = commonBkAPI + "channel/list"
let GetvideoSubscriptions = commonBkAPI + "subscription/video?video_id="
let SubscriptionTransaction = commonBkAPI +  "subscription/updateTransaction"
let GetDianamicHome = commonBkAPI + "show/list?offset="
let GetDianamicHomeWithoutOffset = commonBkAPI + "show/list?"
let getFilmUrl = commonBkAPI + "show/filmoftheweek/list?"
let GetFeaturedVideos = commonBkAPI + "video/featured?"
let GetNewsDetails = commonBkAPI + "show/id?"

let getHomeNewArrivalsApiUrl = commonBkAPI + "show/newarrivals?"
let GetFreeShows = commonBkAPI + "show/free/list?"
let GetPubID = commonBkAPI +  "publisher/id?"
let GetvideoAccordingToShows = commonBkAPI + "api/getShowVideosUpdated?"
let GetvideoByCategory = commonBkAPI + "category/id/shows?"
let GetLogOUtUrl = commonBkAPI +  "account/logout?"
let GetHomeChannelvideo = commonBkAPI + "channel/id?"
let GetPartnerByCategory1 = commonBkAPI + "partner/partner_id/videos"

let GenerateVideoToken = commonAPI + "api/GenerateToken?"
let GetShowNameData = commonBkAPI + "show/id?"
let GetSelectedVideo = commonBkAPI + "video/"
let GetCategories = commonBkAPI + "category/list?"
let GetWatchlistUpdated = commonBkAPI + "watchlist/show?"
let GetWatchlistShows = commonBkAPI + "watchlist/show/"
let getWatchListFlag = commonBkAPI + "watchlist/show/id"
let LoginFromMobileApi = commonBkAPI + "account/code/validate/"

let GetWatchlist = commonBkAPI + "api/GetWatchlist?"
let resendOtp1 = commonBkAPI + "account/otp/resend?"
let RegisterApi = commonBkAPI + "account/register?"
let verifyOtpFromEmail = commonBkAPI + "account/otp/verify?"
let GetGustUserLogin = commonBkAPI + "account/register/guest"
let GenerateLiveToken = commonAPI + "api/GenerateTokenLive"



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

//image
let imageUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/thumbnails/"
let channelUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"
let languageUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/language_icons/"
let showUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/show_logo/"
let youtubeUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"

//Analaytics

let APP_LAUNCH = "https://analytics.poppo.tv/device"
let eventAPI = "https://analytics.poppo.tv/event"
