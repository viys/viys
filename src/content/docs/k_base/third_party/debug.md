---
title: 嵌入式DEBUG方法
---

# 嵌入式DEBUG方法

## 断言

```c
#include <stdio.h>

#ifndef assert_printf

#error need define assert_printf

#else

#ifndef NDEBUG

#if __STDC_VERSION__ < 199901L && !defined(__func__)
# if __GNUC__ >= 2
#  define __func__ __FUNCTION__
# else
#  define __func__ "<unknown>"
# endif
#endif

# define vassert(condition, format, ...) do {                           \
        if(!(condition)) {                                              \
            assert_printf("WARNING: %s:%d: %s:"                         \
                    " Assertion \"%s\" failed.\r\n",                    \
                    __FILE__, __LINE__, __func__, #condition);          \
            while(1){};                                                 \
        }else{                                                          \
            assert_printf(format, ##__VA_ARGS__);                       \
        }                                                               \
    } while(0)

#else

#define vassert(condition, format, ...) do {}while(0)

#endif

#endif
```

## 彩色日志

```c
#include <stdio.h>

#define DBG_UART printf

#ifdef CONFIG_DEBUG

extern int log_num;

#ifdef CONFIG_DEBUG_COLOR_MODE
#define COLOR_SET(dis_mode, fwd_color, bak_color) DBG_UART("\033[%d;%d;%dm", dis_mode, fwd_color, bak_color)
#else
#define COLOR_SET(dis_mode, fwd_color, bak_color) (NULL)
#endif

/*
x:背景色
y:前景色
z:特殊效果
*/
#define DBG_LOG(x, y, z, str, ...)    \
    {                                 \
        COLOR_SET(x, y, z);           \
        DBG_UART(str, ##__VA_ARGS__); \
        COLOR_SET(0, 0, 0);           \
    }
/*
 *  I:INFO W:WARN E:ERR F:FLAG
 */
#if CONFIG_DEBUG_LEVEL >= 0x01
#define DBG_E(str, ...)                                   \
    {                                                     \
        COLOR_SET(31, 31, 1);                             \
        DBG_UART("[%05d] E/%-4s: ", log_num++, DBG_NAME); \
        DBG_UART(str, ##__VA_ARGS__);                     \
        COLOR_SET(0, 0, 0);                               \
    }
#else
#define DBG_E(str, ...) while(0)
#endif
#if CONFIG_DEBUG_LEVEL >= 0x02
#define DBG_W(str, ...)                                   \
    {                                                     \
        COLOR_SET(33, 33, 1);                             \
        DBG_UART("[%05d] W/%-4s: ", log_num++, DBG_NAME); \
        DBG_UART(str, ##__VA_ARGS__);                     \
        COLOR_SET(0, 0, 0);                               \
    }
#else
#define DBG_W(str, ...) while(0)
#endif
#if CONFIG_DEBUG_LEVEL >= 0x03
#define DBG_F(str, ...)                                   \
    {                                                     \
        COLOR_SET(36, 36, 1);                             \
        DBG_UART("[%05d] F/%-4s: ", log_num++, DBG_NAME); \
        DBG_UART(str, ##__VA_ARGS__);                     \
        COLOR_SET(0, 0, 0);                               \
    }
#else
#define DBG_F(str, ...) while(0)
#endif
#if CONFIG_DEBUG_LEVEL >= 0x04
#define DBG_I(str, ...)                                   \
    {                                                     \
        DBG_UART("[%05d] I/%-4s: ", log_num++, DBG_NAME); \
        DBG_UART(str, ##__VA_ARGS__);                     \
    }
#else
#define DBG_I(str, ...) while(0)
#endif
#else
#define DBG_I(str, ...) while(0)
#define DBG_W(str, ...) while(0)
#define DBG_E(str, ...) while(0)
#define DBG_F(str, ...) while(0)
#endif
```