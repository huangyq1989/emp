package test;

import org.apache.commons.collections4.CollectionUtils;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class DeleteFile {

    //存放文件夹
    public static final String baseFilePath = "/Users/huangyq/Movies/21323/Thunder/";




    //循环获取
    public static void main(String[] args) throws IOException {
        File file = new File(baseFilePath);
        final File[] files = file.listFiles();
        for (File file1 : files) {
            System.out.println(file1);
            File[] detailList = file1.listFiles();
            if(detailList != null && detailList.length > 0){
                List<File> temp = Arrays.stream(detailList).filter(item -> item.getName().lastIndexOf(".torrent") == -1).collect(Collectors.toList());
                if(CollectionUtils.isNotEmpty(temp)){
                    continue;
                }
            }
            DeleteFile.deleteFile(file1);
        }
    }


    public static void deleteFile(File file) {
        if(!file.exists()){//判断文件是否存在
            System.out.println("文件不存在！");
            return ;
        }else{
            File files[]=file.listFiles();
            for(File newfile:files){//遍历文件夹下的目录
                if(newfile.isFile()){//如果是文件而不是文件夹==>可直接删除
                    System.out.println("已删除"+newfile.getName());
                    newfile.delete();
                }else{
                    deleteFile(newfile);//是文件夹,递归调用方法
                }
            }
            System.out.println("已删除"+file.getName());
            file.delete();

        }
    }

}
