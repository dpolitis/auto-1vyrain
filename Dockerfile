FROM fedora:latest

ENV WORKSPACE /workspace
WORKDIR /workspace

COPY . .

RUN rm Dockerfile; \
    curl -RO https://raw.githubusercontent.com/n4ru/1vyrain/master/start.sh; \
    chmod +x scripts/build-iso.sh

RUN dnf update --refresh -y; \
    dnf install --refresh -y \
    kernel \
    kernel-devel-$(uname -r) \
    python2 \
    python2-wheel \
    python2-devel \
    gcc \
    nasm \
    redhat-rpm-config \
    elfutils-libelf-devel \
    git \
    cmake \
    coreutils \
    libglvnd-devel \
    make \
    qhexedit2-qt5-devel \
    qt5-qtbase-devel \
    zlib-devel \
    pciutils-devel \
    libusb-devel \
    libjaylink-devel \
    libftdi-devel \
    innoextract \
    livecd-tools

RUN git clone https://github.com/chipsec/chipsec.git chipsec-build; \
    mkdir chipsec; \
    cd chipsec-build; \
    python2 setup.py bdist_wheel; \
    cp dist/*.whl $WORKSPACE/chipsec/; \
    cd ../; \
    rm -rf chipsec-build

RUN git clone https://github.com/LongSoft/UEFITool.git uefitool-build; \
    mkdir uefipatch; \
    cd uefitool-build; \
    git checkout $(git describe --tags); \
    cd UEFIPatch; \
    qmake-qt5 uefipatch.pro; \
    make; \
    cp UEFIPatch patches-misc.txt patches.txt $WORKSPACE/uefipatch/; \
    cd ../../; \
    rm -rf uefitool-build

RUN git clone https://github.com/flashrom/flashrom.git flashrom-build; \
    mkdir $WORKSPACE/flashrom; \
    cd flashrom-build; \
    git checkout $(git describe --tags); \
    make; \
    chmod +x flashrom; \
    cp flashrom $WORKSPACE/flashrom/; \
    cd ../; \
    rm -rf flashrom-build

RUN mkdir $WORKSPACE/bios; \
    cd $WORKSPACE/bios; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/g2uj33us.exe -o X230.exe; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/gcuj34us.exe -o X230t.exe; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/g5uj39us.exe -o W530.exe; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/g4uj41us.exe -o T530.exe; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/g7uj29us.exe -o T430s.exe; \
    curl -R https://download.lenovo.com/pccbbs/mobiles/g1uj49us.exe -o T430.exe; \
    cp X230.exe X330.exe; \
    for bios in `ls *.exe`; \
        do innoextract $bios && find . -type f -name "*.FL1" \
	-exec cp {} $(basename -s .exe $bios).FL1 \; && rm -rf app && \
	bash $WORKSPACE/patcher/patcher.sh $(basename -s .exe $bios).FL1; \
    done

ENTRYPOINT ["/workspace/scripts/build-iso.sh"]
CMD ["/workspace/ks/livecd-fedora-minimal.ks"]
