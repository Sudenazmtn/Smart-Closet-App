class LocaleKeys {
  LocaleKeys._();

  // ── App ───────────────────────────────────────────────────────────────────
  static const appName        = 'appName';
  static const appTagline     = 'appTagline';
  static const appSlogan      = 'appSlogan';
  static const appSloganSub   = 'appSloganSub';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const authGetStarted          = 'auth.getStarted';
  static const authSignIn              = 'auth.signIn';
  static const authSignInTitle         = 'auth.signInTitle';
  static const authSignInSubtitle      = 'auth.signInSubtitle';
  static const authSignUp              = 'auth.signUp';
  static const authSignUpTitle         = 'auth.signUpTitle';
  static const authSignUpSubtitle      = 'auth.signUpSubtitle';
  static const authSignOut             = 'auth.signOut';
  static const authContinueWithGoogle  = 'auth.continueWithGoogle';
  static const authAlreadyHaveAccount  = 'auth.alreadyHaveAccount';
  static const authDontHaveAccount     = 'auth.dontHaveAccount';
  static const authForgotPassword      = 'auth.forgotPassword';
  static const authForgotPasswordTitle    = 'auth.forgotPasswordTitle';
  static const authForgotPasswordSubtitle = 'auth.forgotPasswordSubtitle';
  static const authSendResetLink       = 'auth.sendResetLink';
  static const authBackToSignIn        = 'auth.backToSignIn';
  static const authRememberedPassword  = 'auth.rememberedPassword';
  static const authSecurityNote        = 'auth.securityNote';

  // ── Field ─────────────────────────────────────────────────────────────────
  static const fieldFullName          = 'field.fullName';
  static const fieldEmail             = 'field.email';
  static const fieldPassword          = 'field.password';
  static const fieldConfirmPassword   = 'field.confirmPassword';
  static const fieldHintFullName      = 'field.hintFullName';
  static const fieldHintEmail         = 'field.hintEmail';
  static const fieldHintPassword      = 'field.hintPassword';
  static const fieldHintConfirmPassword = 'field.hintConfirmPassword';
  static const fieldHintEmailAddress  = 'field.hintEmailAddress';
  static const fieldHintItemName      = 'field.hintItemName';

  // ── Validation ────────────────────────────────────────────────────────────
  static const validationRequired        = 'validation.required';
  static const validationEmailInvalid    = 'validation.emailInvalid';
  static const validationPasswordShort   = 'validation.passwordShort';
  static const validationPasswordMismatch = 'validation.passwordMismatch';

  // ── Home ──────────────────────────────────────────────────────────────────
  static const homeGoodMorning      = 'home.goodMorning';
  static const homeGoodAfternoon    = 'home.goodAfternoon';
  static const homeGoodEvening      = 'home.goodEvening';
  static const homeAiButton         = 'home.aiButton';
  static const homeAiButtonSub      = 'home.aiButtonSub';
  static const homeSectionWardrobe  = 'home.sectionWardrobe';
  static const homeSectionOutfit    = 'home.sectionOutfit';
  static const homeViewAll          = 'home.viewAll';
  static const homeMatchPercent     = 'home.matchPercent';

  // ── Wardrobe ──────────────────────────────────────────────────────────────
  static const wardrobeTitle          = 'wardrobe.title';
  static const wardrobeItemCount      = 'wardrobe.itemCount';
  static const wardrobeFilterAll      = 'wardrobe.filterAll';
  static const wardrobeFilterTops     = 'wardrobe.filterTops';
  static const wardrobeFilterBottoms  = 'wardrobe.filterBottoms';
  static const wardrobeFilterDresses  = 'wardrobe.filterDresses';
  static const wardrobeFilterOuterwear = 'wardrobe.filterOuterwear';
  static const wardrobeFilterShoes    = 'wardrobe.filterShoes';
  static const wardrobeFilterBags     = 'wardrobe.filterBags';

  // ── Add Item ──────────────────────────────────────────────────────────────
  static const addItemTitle         = 'addItem.title';
  static const addItemSave          = 'addItem.save';
  static const addItemPhotoPrompt   = 'addItem.photoPrompt';
  static const addItemAutoClassify  = 'addItem.autoClassify';
  static const addItemFieldName     = 'addItem.fieldName';
  static const addItemFieldCategory = 'addItem.fieldCategory';
  static const addItemFieldSeason   = 'addItem.fieldSeason';
  static const addItemFieldColor    = 'addItem.fieldColor';

  // ── Season ────────────────────────────────────────────────────────────────
  static const seasonSpring = 'season.spring';
  static const seasonSummer = 'season.summer';
  static const seasonFall   = 'season.fall';
  static const seasonWinter = 'season.winter';
  static const seasonAll    = 'season.all';

  // ── Color ─────────────────────────────────────────────────────────────────
  static const colorBeige = 'color.beige';
  static const colorBlack = 'color.black';
  static const colorWhite = 'color.white';
  static const colorNavy  = 'color.navy';
  static const colorRed   = 'color.red';

  // ── Outfit ────────────────────────────────────────────────────────────────
  static const outfitTitle        = 'outfit.title';
  static const outfitEventCasual  = 'outfit.eventCasual';
  static const outfitEventWork    = 'outfit.eventWork';
  static const outfitEventSport   = 'outfit.eventSport';
  static const outfitEventEvening = 'outfit.eventEvening';
  static const outfitAiLabel      = 'outfit.aiLabel';
  static const outfitClaudeSays   = 'outfit.claudeSays';
  static const outfitSave         = 'outfit.save';
  static const outfitAskPlaceholder = 'outfit.askPlaceholder';

  // ── Stats ─────────────────────────────────────────────────────────────────
  static const statsTitle        = 'stats.title';
  static const statsOverview     = 'stats.overview';
  static const statsPeriodWeek   = 'stats.periodWeek';
  static const statsPeriodMonth  = 'stats.periodMonth';
  static const statsPeriodAllTime = 'stats.periodAllTime';
  static const statsChartLabel   = 'stats.chartLabel';
  static const statsMostWorn     = 'stats.mostWorn';
  static const statsWornTimes    = 'stats.wornTimes';
  static const statsNeverWorn    = 'stats.neverWorn';
  static const statsNeverWornSub = 'stats.neverWornSub';

  // ── Profile ───────────────────────────────────────────────────────────────
  static const profileTitle              = 'profile.title';
  static const profileEditButton         = 'profile.editButton';
  static const profileStatItems          = 'profile.statItems';
  static const profileStatOutfits        = 'profile.statOutfits';
  static const profileStatAiUses         = 'profile.statAiUses';
  static const profileMenuEditProfile    = 'profile.menuEditProfile';
  static const profileMenuEditProfileSub = 'profile.menuEditProfileSub';
  static const profileMenuNotifications  = 'profile.menuNotifications';
  static const profileMenuNotificationsSub = 'profile.menuNotificationsSub';
  static const profileMenuLocation       = 'profile.menuLocation';
  static const profileMenuPrivacy        = 'profile.menuPrivacy';
  static const profileMenuPrivacySub     = 'profile.menuPrivacySub';

  // ── Nav ───────────────────────────────────────────────────────────────────
  static const navHome     = 'nav.home';
  static const navWardrobe = 'nav.wardrobe';
  static const navAi       = 'nav.ai';
  static const navProfile  = 'nav.profile';

  // ── Error ─────────────────────────────────────────────────────────────────
  static const errorGeneral            = 'error.general';
  static const errorNoInternet         = 'error.noInternet';
  static const errorInvalidCredentials = 'error.invalidCredentials';
  static const errorEmailInUse         = 'error.emailInUse';
  static const errorWeakPassword       = 'error.weakPassword';
  static const errorUserNotFound       = 'error.userNotFound';

  // ── Success ───────────────────────────────────────────────────────────────
  static const successResetEmailSent = 'success.resetEmailSent';
  static const successItemAdded      = 'success.itemAdded';
  static const successOutfitSaved    = 'success.outfitSaved';

  // ── Common ────────────────────────────────────────────────────────────────
  static const commonCancel               = 'common.cancel';
  static const commonDelete               = 'common.delete';
  static const commonSave                 = 'common.save';
  static const commonLoading              = 'common.loading';
  static const commonRetry                = 'common.retry';
  static const commonDeleteConfirmTitle   = 'common.deleteConfirmTitle';
  static const commonDeleteConfirmMessage = 'common.deleteConfirmMessage';
}