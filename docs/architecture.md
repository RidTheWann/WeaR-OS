# WeaR OS Architecture

## Principle

WeaR OS is a custom ROM product layer on top of LineageOS/AOSP. The duchamp
device tree remains the hardware authority.

```text
AOSP / LineageOS
        |
        +-- device/xiaomi/duchamp
        |      +-- Snapboss device implementation
        |      +-- native shims
        |      +-- UDFPS / vibrator
        |      +-- overlays / sepolicy
        |      +-- power / thermal
        |      +-- VINTF / init / configs
        |
        +-- vendor/xiaomi/duchamp
        +-- MediaTek / Xiaomi platform dependencies
        |
        +-- vendor/wear
               +-- WeaR product
               +-- future WeaR Settings / SystemUI
               +-- future performance services
```

## Modification boundary

Device-specific hardware fixes belong in the device tree or the dependency that
owns the interface. ROM features belong in WeaR or in the upstream component they
actually modify.

Do not change the kernel, thermal policy, sepolicy, HAL behavior, and framework
features in one commit. Each subsystem needs an isolated change and regression test.

## Development milestones

### Alpha 0.1 — Reference build

1. Sync the exact source stack.
2. Build `lineage_duchamp-userdebug` if a reference baseline is needed.
3. Build `wear_duchamp-userdebug`.
4. Boot-test the result.

### Alpha 0.2 — WeaR identity

Move branding/UI identity into a first-class WeaR layer without changing hardware behavior.

### Alpha 0.3 — WeaR features

Implement real Java/Kotlin/C++ features such as Settings, SystemUI integrations,
performance controls, and game-mode services.

### Alpha 0.4 — Power/thermal

Only after baseline stability, profile power and thermal behavior using measured
device data rather than undocumented property tweaks.
