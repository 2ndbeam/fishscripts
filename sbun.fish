# uses tar, p7zip, unzip, unrar-free utilities
function sbun
    argparse h/help f/folder -- $argv or return

    if set -ql _flag_h
        echo "Usage: sbun [-h|--help] file [-f/folder [folder]]\n
    -h              Show this message
    -f --folder     Pass the folder to extract to;
                    if it doesn't exist, it is created
    Available formats: zip, tar, 7z, rar"
        return 0
    end

    set arch_loc $argv[1]

    if set -ql _flag_f
        set cd_loc (pwd)
        set arch_loc (string join / $cd_loc $argv[1])

        if test -e $argv[2]
            if not test -d $argv[2]
                echo "$argv[2] exists and is not a directory. Aborting..."
                return
            end
        else
            mkdir $argv[2]
        end

        cd $argv[2]
    end

    set splitted_file (string split . $argv[1])

    set ext $splitted_file[-1]

    if test $splitted_file[-2] = tar
        set ext tar
    end

    switch (echo $ext)
        case zip
            unzip $arch_loc
        case tar
            tar -xf $arch_loc
        case 7z
            7z x $arch_loc
        case rar
            unrar-free $arch_loc
        case '*'
            echo "Unknown extension .$ext"
            return
    end

    if set -ql _flag_f
        cd $cd_loc
    end
end
