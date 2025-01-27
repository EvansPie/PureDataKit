#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AudioHelpers.h"
#import "m_pd.h"
#import "PdAudioController.h"
#import "PdAudioUnit.h"
#import "PdBase.h"
#import "PdDispatcher.h"
#import "PdFile.h"
#import "PdMidiDispatcher.h"
#import "ringbuffer.h"
#import "z_hooks.h"
#import "z_libpd.h"
#import "z_print_util.h"
#import "z_queued.h"

FOUNDATION_EXPORT double PureDataKitVersionNumber;
FOUNDATION_EXPORT const unsigned char PureDataKitVersionString[];

