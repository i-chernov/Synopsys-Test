
## Описание
Write a Dockerfile which builds a container image suitable for building custom Linux distribution with help of Buildroot (https://git.buildroot.org/buildroot), optionally run built distro in QEMU (instructions on execution in QEMU are available in https://git.buildroot.org/buildroot/tree/board/qemu/_BOARD_NAME_/readme.txt). 

You may want to use "buildroot/base:latest" as a base image (if of any interest it's built with https://git.buildroot.org/buildroot/tree/support/docker/Dockerfile) so that all host dependencies are in place.

Container should accept at least 1 input parameter: so-called Buildroot "defconfig" (see full list of those here: https://git.buildroot.org/buildroot/tree/configs). Good examples are: "qemu_x86_64_defconfig" or "qemu_aarch64_virt_defconfig".

Built artifacts such as Linux kernel binary (typically "vmlinu*" or "*Image"), Device Tree blob ("*.dtb") and root filesystem image ("rootfs.*") should be available on host (i.e. outside the container). If boot test in QEMU is being done, boot log should be put next to build artifacts.

## Сборка контейнера
- `BUILDROOT_VERSION` - Версия Buildroot (обязательный аргумент)
```bash
docker build --build-arg BUILDROOT_VERSION=2020.11.2 --tag buildroot-2020.11.2 .
```

## Запуск
- `--mount` - Примонтирует директорию *`/home/br-user/artifacts/`* к директории хоста *`<HOST_ARTIFACTS_DIR>`*
- `--rm` - Удалит контейнер после завершения работы
- `buildroot-2020.11.2` - Название образа
- `<defconfig>` - Имя файла конфигурации, например `qemu_x86_64_defconfig`
```bash
docker run --mount "type=bind,src=<HOST_ARTIFACTS_DIR>,dst=/home/br-user/artifacts/" --rm buildroot-2020.11.2 <defconfig>
```
## Пример
Запустим контейнер для сборки из файла *`qemu_x86_64_defconfig`*
```bash
docker run --mount "type=bind,src=/mnt/d/Source/Synopsys-Test/artifacts/,dst=/home/br-user/artifacts/" --rm buildroot-2020.11.2 qemu_x86_64_defconfig
```

После сборки в директории `artifacts/` появится каталог *`qemu_x86_64-2021_02_04_17_34`* с необходимыми файлами.
```bash
$ tree artifacts
artifacts/
└── qemu_x86_64-2021_02_04_17_34
    ├── bamboo.dtb
    ├── buildroot-build-error.log
    ├── bzImage
    ├── canyonlands.dtb
    ├── petalogix-ml605.dtb
    ├── petalogix-s3adsp1800.dtb
    ├── qemu-boot-test.log
    ├── rootfs.ext2
    └── start-qemu.sh
``` 