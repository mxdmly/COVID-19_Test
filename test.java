import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import org.junit.Test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.nio.charset.StandardCharsets;

/**
* 描述: 医保接口调用示例
*
* @author wangjl
*/
public class testDemo {
    private static final String url = "http://10.97.240.206:80/ebus/gdyb_inf/poc/hsa/hgs";

    /** 按照报文要求传入 JSON 格式字符串 */
    private static final String downInput = "{"infno":"9001","msgid":"H44180200009202104111830002","mdtrtarea_admvs":"441200","insuplc_admdvs":"","recer_sys_code":"441500","dev_no":"","dev_safe_info":"","cainfo":"","signtype":"SM3","infver":"V1.0","opter_type":"1","opter":"1099","opter_name":"超级管理员","inf_time":"2021-04-11 18:30:00","fixmedins_code":"H44120200141","fixmedins_name":"肇庆市端州区人民医院","sign_no":"10196016","input":{"signIn":{"opter_no":"1099","mac":"70-B5-E8-3F-1C-34","ip":"168.168.210.100"}}}";

    /**
    * 调用普通交易及文件下载交易
    */
    @Test
    public void test1() {
        CloseableHttpClient httpclient = HttpClients.createDefault();
        HttpPost httppost = new HttpPost(url);
        RequestConfig requestConfig = RequestConfig.custom()
                                                   .setConnectTimeout(10000)
                                                   .setSocketTimeout(10000)
                                                   .build();
        httppost.setConfig(requestConfig);
        ByteArrayEntity entity = new ByteArrayEntity(downInput.getBytes(
                    StandardCharsets.UTF_8));
        entity.setContentType("text/plain");
        httppost.setEntity(entity);
        CloseableHttpResponse response = null;
        try {
            response = httpclient.execute(httppost);

            int statusCode = response.getStatusLine().getStatusCode();

            if (statusCode != HttpStatus.SC_OK) {
                httppost.abort();
                throw new RuntimeException("HttpClient,error status code :" +
                    statusCode);
            }
            HttpEntity responseEntity = response.getEntity();
            String result;
            if (responseEntity != null) {
                if (responseEntity.getContentType().getValue()
                                      .contains("application/octet-stream")) {
                    InputStream content = responseEntity.getContent();
                    //返回文件流
                    File file = new File("testDownload.txt");
                    FileOutputStream fileOutputStream = new FileOutputStream(file);
                    int temp;
                    while ((temp = content.read()) != -1) {
                        fileOutputStream.write(temp);
                    }
                    fileOutputStream.close();
                } else {
                    //返回字符串
                    result = EntityUtils.toString(responseEntity, "UTF-8");
                    System.out.println(result);
                }
            }
            EntityUtils.consume(entity);
        } catch (ClientProtocolException e) {
            throw new RuntimeException("提交给服务器的请求，不符合 HTTP 协议", e);
        } catch (IOException e) {
            throw new RuntimeException("向服务器承保接口发起 http 请求,执行 post 请求异常", e);
        } finally {
            if (response != null) {
                try {
                    response.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (httpclient != null) {
                try {
                    httpclient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
    * 调用文件上传交易
    */
    @Test
    public void test2() {
        File file = new File("testUpload.txt");
        CloseableHttpClient httpclient = HttpClients.createDefault();
        HttpPost httppost = new HttpPost(url);
        RequestConfig requestConfig = RequestConfig.custom()
                                                   .setConnectTimeout(10000)
                                                   .setSocketTimeout(10000)
                                                   .build();
        httppost.setConfig(requestConfig);
        MultipartEntityBuilder builder = MultipartEntityBuilder.create();
        builder.setCharset(StandardCharsets.UTF_8);
        builder.addTextBody("jsonStr", upInput);
        builder.addBinaryBody("file", file, ContentType.DEFAULT_BINARY,
            "testUpload.txt");
        HttpEntity entity = builder.build();
        httppost.setEntity(entity);
        CloseableHttpResponse response = null;
        try {
            response = httpclient.execute(httppost);

            int statusCode = response.getStatusLine().getStatusCode();

            if (statusCode != HttpStatus.SC_OK) {
                httppost.abort();
                throw new RuntimeException("HttpClient,error status code :" +
                    statusCode);
            }

            HttpEntity responseEntity = response.getEntity();
            String result;

            if (responseEntity != null) {
                //返回字符串
                result = EntityUtils.toString(responseEntity, "UTF-8");
                System.out.println(result);
            }
            EntityUtils.consume(entity);
        } catch (ClientProtocolException e) {
            throw new RuntimeException("提交给服务器的请求，不符合 HTTP 协议", e);
        } catch (IOException e) {
            throw new RuntimeException("向服务器承保接口发起 http 请求,执行 post 请求异常", e);
        } finally {
            if (response != null) {
                try {
                    response.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (httpclient != null) {
                try {
                    httpclient.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
