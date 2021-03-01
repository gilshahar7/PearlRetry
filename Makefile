FINALPACKAGE = 1
ARCHS = armv7 arm64 arm64e
export TARGET = iphone:clang:11.2:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PearlRetry
PearlRetry_FILES = Tweak.xm
PearlRetry_PRIVATE_FRAMEWORKS = SpringBoardUIServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += pearlretryprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
