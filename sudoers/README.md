# sudoers config

该工具用于配置sudoer用户

## 使用方法

1.  下载并测试

    ```shell
    wget https://raw.githubusercontent.com/aauutthh/deb_config/master/sh
    ./sh testsh a b c
    ```

    输出:
    ```txt
    PROGIT=deb_config.git
    PROJECT=deb_config
    3 
    a b c 
    ```

1. 运行自动配置 
    `sudo ./sh sudoers/setsudoer.sh  daniel`

1. 手动执行配置:

    如果自动配置了，就不需要手动，以下步骤供

    ```shell
    export DEBUGING="1" 
    ./sh sudoers/setsudoer.sh  daniel
    ```
    
    生成两个文件:
    ```txt
    /tmp/etc/sudoers.d/nopassfile
    /tmp/etc/sudoers.d/daniel
    ```
    
    用root移动到`/etc/sudoers.d/`目录下

