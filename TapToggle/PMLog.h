#import <Lumberjack/DDLog.h>

// We want to use the following log levels:
// 
// Fatal
// Error
// Warn
// Notice
// Info
// Debug
// 
// All we have to do is undefine the default values,
// and then simply define our own however we want.

// First undefine the default stuff we don't want to use.

#undef LOG_FLAG_ERROR
#undef LOG_FLAG_WARN
#undef LOG_FLAG_INFO
#undef LOG_FLAG_VERBOSE

#undef LOG_LEVEL_ERROR
#undef LOG_LEVEL_WARN
#undef LOG_LEVEL_INFO
#undef LOG_LEVEL_VERBOSE

#undef LOG_ERROR
#undef LOG_WARN
#undef LOG_INFO
#undef LOG_VERBOSE

#undef DDLogError
#undef DDLogWarn
#undef DDLogInfo
#undef DDLogVerbose

#undef DDLogCError
#undef DDLogCWarn
#undef DDLogCInfo
#undef DDLogCVerbose

// Now define everything how we want it
#define PM_LEVEL_FATAL  0
#define PM_LEVEL_ERROR  1
#define PM_LEVEL_WARN   2
#define PM_LEVEL_NOTICE 3
#define PM_LEVEL_INFO   4
#define PM_LEVEL_DEBUG  5

#define LOG_FLAG_FATAL   (1 << 0)  // 0...000001
#define LOG_FLAG_ERROR   (1 << 1)  // 0...000010
#define LOG_FLAG_WARN    (1 << 2)  // 0...000100
#define LOG_FLAG_NOTICE  (1 << 3)  // 0...001000
#define LOG_FLAG_INFO    (1 << 4)  // 0...010000
#define LOG_FLAG_DEBUG   (1 << 5)  // 0...100000

#define LOG_LEVEL_FATAL   (LOG_FLAG_FATAL)                     // 0...000001
#define LOG_LEVEL_ERROR   (LOG_FLAG_ERROR  | LOG_LEVEL_FATAL ) // 0...000011
#define LOG_LEVEL_WARN    (LOG_FLAG_WARN   | LOG_LEVEL_ERROR ) // 0...000111
#define LOG_LEVEL_NOTICE  (LOG_FLAG_NOTICE | LOG_LEVEL_WARN  ) // 0...001111
#define LOG_LEVEL_INFO    (LOG_FLAG_INFO   | LOG_LEVEL_NOTICE) // 0...011111
#define LOG_LEVEL_DEBUG   (LOG_FLAG_DEBUG  | LOG_LEVEL_INFO  ) // 0...111111


#ifdef DEBUG
static int pmLogLevel = LOG_LEVEL_DEBUG;
#else
static int pmLogLevel = LOG_LEVEL_WARN;
#endif

#define LOG_FATAL   (pmLogLevel & LOG_FLAG_FATAL )
#define LOG_ERROR   (pmLogLevel & LOG_FLAG_ERROR )
#define LOG_WARN    (pmLogLevel & LOG_FLAG_WARN  )
#define LOG_NOTICE  (pmLogLevel & LOG_FLAG_NOTICE)
#define LOG_INFO    (pmLogLevel & LOG_FLAG_INFO  )
#define LOG_DEBUG   (pmLogLevel & LOG_FLAG_DEBUG )

// OBJ-C Log level by name
#define PMLogFatal(frmt, ...)    SYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_FATAL,  0, frmt, ##__VA_ARGS__)
#define PMLogError(frmt, ...)    SYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_ERROR,  0, frmt, ##__VA_ARGS__)
#define PMLogWarn(frmt, ...)    ASYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_WARN,   0, frmt, ##__VA_ARGS__)
#define PMLogNotice(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_NOTICE, 0, frmt, ##__VA_ARGS__)
#define PMLogInfo(frmt, ...)    ASYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_INFO,   0, frmt, ##__VA_ARGS__)
#define PMLogDebug(frmt, ...)   ASYNC_LOG_OBJC_MAYBE(pmLogLevel, LOG_FLAG_DEBUG,  0, frmt, ##__VA_ARGS__)

// OBJ-C Log Level by number
#define PMLog0(frmt, ...) PMLogFatal(frmt,  ##__VA_ARGS__)
#define PMLog1(frmt, ...) PMLogError(frmt,  ##__VA_ARGS__)
#define PMLog2(frmt, ...) PMLogWarn(frmt,  ##__VA_ARGS__)
#define PMLog3(frmt, ...) PMLogNotice(frmt,  ##__VA_ARGS__)
#define PMLog4(frmt, ...) PMLogInfo(frmt,  ##__VA_ARGS__)
#define PMLog5(frmt, ...) PMLogDebug(frmt,  ##__VA_ARGS__)

// Glue number to name
#define PMLOG_2(level, format, ...) PMLog##level (format, ##__VA_ARGS__)
#define PMLOG(level, format, ...) PMLOG_2(level, format, ##__VA_ARGS__)

#define PMHERE PMLogDebug(@"File:%@ Method:%s", THIS_FILE, __FUNCTION__)

// C Log level by name
#define PMLogCFatal(frmt, ...)   SYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_FATAL,  0, frmt, ##__VA_ARGS__)
#define PMLogCError(frmt, ...)   SYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_ERROR,  0, frmt, ##__VA_ARGS__)
#define PMLogCWarn(frmt, ...)   ASYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_WARN,   0, frmt, ##__VA_ARGS__)
#define PMLogCNotice(frmt, ...) ASYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_NOTICE, 0, frmt, ##__VA_ARGS__)
#define PMLogCInfo(frmt, ...)   ASYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_INFO,   0, frmt, ##__VA_ARGS__)
#define PMLogCDebug(frmt, ...)  ASYNC_LOG_C_MAYBE(pmLogLevel, LOG_FLAG_DEBUG,  0, frmt, ##__VA_ARGS__)

// C Log Level by number
#define PMLogC0(frmt, ...) PMLogCFatal(frmt, ##__VA_ARGS__)
#define PMLogC1(frmt, ...) PMLogCError(frmt, ##__VA_ARGS__)
#define PMLogC2(frmt, ...) PMLogCWarn(frmt, ##__VA_ARGS__)
#define PMLogC3(frmt, ...) PMLogCNotice(frmt, ##__VA_ARGS__)
#define PMLogC4(frmt, ...) PMLogCInfo(frmt, ##__VA_ARGS__)
#define PMLogC5(frmt, ...) PMLogCDebug(frmt, ##__VA_ARGS__)

// Glue number to name
#define PMLOGC_2(level, format, ...) PMLogC##level (format, ##__VA_ARGS__)
#define PMLOGC(level, format, ...) PMLOGC_2(level, format, ##__VA_ARGS__)

#define PMHEREC PMLogCDebug(@"File:%@ Method:%s", THIS_FILE, __FUNCTION__)
