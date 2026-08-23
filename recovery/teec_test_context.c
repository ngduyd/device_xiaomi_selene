/*
 * teec_test_context - Quick probe for TEEC readiness.
 * Returns 0 if TEEC_InitializeContext succeeds, 1 otherwise.
 * Used by wait_for_tee.sh to poll TEE readiness before starting beanpod.
 */

#include <stdio.h>
#include <stdint.h>

typedef uint32_t TEEC_Result;
struct TEEC_Context { void *fd; };
#define TEEC_SUCCESS 0x0

extern TEEC_Result TEEC_InitializeContext(const char *name,
                                          struct TEEC_Context *ctx);
extern void TEEC_FinalizeContext(struct TEEC_Context *ctx);

int main(void)
{
    struct TEEC_Context ctx = {0};
    TEEC_Result rc = TEEC_InitializeContext(NULL, &ctx);
    if (rc == TEEC_SUCCESS) {
        TEEC_FinalizeContext(&ctx);
        return 0;
    }
    return 1;
}
