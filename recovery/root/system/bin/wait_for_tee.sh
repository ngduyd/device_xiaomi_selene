#!/system/bin/sh
# wait_for_tee.sh - poll TEEC readiness, then exec beanpod keymaster.
# Replaces the old fixed `sleep 3` gate, which started keymaster before
# teei_daemon was ready and caused SEGV/crash-leak-retry loops.

TEE_TEST=/system/bin/teec_test_context
BEANPOD=/system/bin/android.hardware.keymaster@4.1-service.beanpod
TIMEOUT_MS=15000
INTERVAL_MS=200

export LD_LIBRARY_PATH=/system/lib64:/system/lib64/hw:/vendor/lib64:/vendor/lib64/hw

elapsed=0
while [ "$elapsed" -lt "$TIMEOUT_MS" ]; do
    if "$TEE_TEST"; then
        exec "$BEANPOD"
    fi
    sleep 0.2 2>/dev/null || sleep 1
    elapsed=$((elapsed + INTERVAL_MS))
done

# Give up after timeout: still try to start beanpod so boot can proceed.
exec "$BEANPOD"
