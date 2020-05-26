R on Fridays 2020-2 by Ryosuke TAJIMA 
==============  
  
# 重回帰分析と主成分分析(多変量解析)
## 重回帰分析
```R  
d1<-read.table("Test1.txt", header=T) # またはd1<-read.csv("Test1.csv")  
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  
corCheck<-cor(sd5[,5:8])# 多重共線性のチェック  
result<-lm(SDW~SPC+RLD, sd5)  
summary(result)  
```  

## 主成分分析
```R  
d3<-read.csv("Test3.csv")  # Test2データは後ほど  
cor(d3[,2:12])
md3<-d3[,5:9]  
resPr1<-prcomp (md3)  
summary(resPr1)  
resPr1$rotation  
smd3<-scale(md3) #正規化  
resPr2<-prcomp (scale(md3))
summary(resPr2)  
resPr2$rotation  
plot(resPr2$x[,1], resPr2$x[,2])
plot(1, 1,col="white", xlim=c(-3,3), ylim=c(-3,3), xlab="PC1", ylab="PC2")
text(resPr2$x[,1], resPr2$x[,2], labels=d3$District)
```  

# 基本的な作図
## 基本の基本
```R  
a<-c(1,3,5,6,12) #数字列
b<-c(2,7,3,16,11) #数字列
barplot(a) # 棒グラフ
plot(a,b) #散布図
plot(a,b, type="l") #線
plot(a,b, type="b") #点と線
plot(a,b, type="o") #点と線を重ねる
plot(a,b, col="red") #基本的な色はだいたいある．
plot(a,b, pch=0) #シンボルの形を変える
plot(a,b, pch=16) #16は便利
plot(a,b, cex=2) #サイズの変更
plot(a,b, type="o", col="red", pch=16, cex=2) #組み合わせられる
# 以下のように構造的に書くとヌケモレがなくなる
plot(a,b,
        type="o",
        col="red",
        pch=16,
        cex=2,
    )
```  
  
## 実際のデータで作成
```R  
d1<-read.table("Test1.txt", header=T)
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  

plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,1),  # x軸の境界
        ylim = c(0,0.5), # y軸の境界
        xlab = "ShootDW", # x軸ラベル
        ylab = "RootDW", # y軸ラベル
        col = "red",
        pch=16,
        cex=1.5,
    )
```  
  
## ライブラリ corrplot
```R  
library(corrplot)
cor<-cor(sd5[,5:8])
corrplot(cor,method="ellipse", type="upper") #methodはnumber, squareなど，typeはlowerも
corrplot.mixed(cor,lower="number",upper='ellipse') # 混ぜられる
```  

## ライブラリ ggplot2  
すごく便利らしいし，実際にそうだと思うが使っていない  
よくわからないので超基本だけ紹介  
基本は重ね書き  
  
```R  
library(ggplot2)
# 散布図  
ggplot(sd5, aes(x=SDW, y=RDW, color=Limitation, shape = Inoculation))+ # データの設定
geom_point() # グラフの種類
# 回帰直線付  
ggplot(d1, aes(x=SDW, y=RDW, color=Stage))+
geom_point()+
geom_smooth(method = "lm")+ #回帰直線の当てはめ  
theme_classic() #グラフの見た目の調整  
```  
  

# 非線形回帰  
## 基本  
```R  
nlsd<-read.table("Test2.txt", header=T)  
x<-nlsd$Time
y<-nlsd$Rootlength
plot(x, y)
result<- nls(y ~K/(1+C*exp(-r*x)), start=c(K=150,r=0.01, C=20))
summary(result)
# 結果の確認
x1<-c(1:300)
y1<-123.2/(1+43.23*exp(-0.03388*x1))
plot(x,y, xlim = c(0,250),ylim = c(0,130), xlab="", ylab="")
par(new=TRUE)
plot(x1,y1, type='l', xlim = c(0,250),ylim = c(0,130), xlab="", ylab="")
```  

## 応用編：窒素の無機化特性  
```R  
nlsd2<-read.table("Test4.txt", header=T)  

# 設定温度毎に切り分け，データ抜き出し
nlsd20<-subset(nlsd2, nlsd2$T==20)
nlsd25<-subset(nlsd2, nlsd2$T==25)
nlsd30<-subset(nlsd2, nlsd2$T==30)
x20<-nlsd20$d; y20<-nlsd20$InN
x25<-nlsd25$d; y25<-nlsd25$InN
x30<-nlsd30$d; y30<-nlsd30$InN

# 定数
N0<-70 #初期の可分解性有機態窒素
R<-8.314 #気体定数

# 非線型回帰
result20<- nls(y20 ~N0*(1-exp(-k*x20)), start=c(k=0.005))
result25<- nls(y25 ~N0*(1-exp(-k*x25)), start=c(k=0.005))
result30<- nls(y30 ~N0*(1-exp(-k*x30)), start=c(k=0.005))
summary(result20)
summary(result25)
summary(result30)

# 結果の抽出・利用
k20<-summary(result20)$coefficients[1]
k25<-summary(result25)$coefficients[1]
k30<-summary(result30)$coefficients[1]
yArr<-log(c(k20, k25, k30))
xArr<-1/(273+c(20,25,30))
result<-lm(yArr~xArr)
summary(result)

# パラメータ算出
A<-exp(summary(result)$coefficients[1]) # 定数
E<--summary(result)$coefficients[2]*R # 活性化エネルギー

# 図示
pred_x<-c(0:28)
pred_y20<-N0*(1-exp(-A*exp(-E/(R*(20+273)))*pred_x))
pred_y25<-N0*(1-exp(-A*exp(-E/(R*(25+273)))*pred_x))
pred_y30<-N0*(1-exp(-A*exp(-E/(R*(30+273)))*pred_x))
x<-nlsd2$d
y<-nlsd2$InN
plot(x,y, xlim = c(0,30),ylim = c(0,60), xlab="", ylab="")
par(new=TRUE)
plot(pred_x,pred_y20, type='l', xlim = c(0,30),ylim = c(0,60), xlab="", ylab="")
par(new=TRUE)
plot(pred_x,pred_y25, type='l', xlim = c(0,30),ylim = c(0,60), xlab="", ylab="")
par(new=TRUE)
plot(pred_x,pred_y30, type='l', xlim = c(0,30),ylim = c(0,60), xlab="", ylab="")
```

## 最適化関数を使って  
``` R
f<-function(set) {
    ypred20<-N0*(1-exp(-set[1]*x20))
    ypred25<-N0*(1-exp(-set[2]*x25))
    ypred30<-N0*(1-exp(-set[3]*x30))
    sum((ypred20-y20)^2)+sum((ypred25-y25)^2)+sum((ypred30-y30)^2)
}
optim(c(0.005, 0.005, 0.005), f)
```

# テキストエディタのススメ
長いコードを書く場合にはテキストエディタがあった方が断然良い  
重要な機能は
- 行番号が出る  
- 不可視文字の表示   
- コードの機能によって色分けしてくれる  
- 軽い  
  
等々  

## Windows
- Visual Studio Code  
- Atom  
- Notepad++  
  
## Mac
- Visual Studio Code  
- Atom  
- Coteditor (私のオススメ．多分少数派)  
  
  
# 大きなデータの扱い
## ライブラリ dplyrの利用  
```R  
# 気象データ  
library(dplyr)
dClimate<-read.csv("Test5.csv")
  
# 2017年
dC2017 <-dClimate %>%
    dplyr::filter(Year==2017)
  
# 1月(2016-2019年)
dCM1 <-dClimate %>%
    dplyr::filter(Month==1)
  
# 2017年1月
dC2017M1 <-dClimate %>%
    dplyr::filter(Year==2017&Month==1)

dC2017M1_2 <-dClimate %>% #この書き方がdplyrっぽい
    dplyr::filter(Year==2017) %>%
    dplyr::filter(Month==1)

# 2017年月別平均気温
d2017MeanMonth <-dClimate %>%
    dplyr::filter(Year==2017) %>%
    dplyr::group_by(Month) %>% #データを月別にグループ化
    dplyr::summarise(Mean=mean(na.omit(Mean)))
  
df2017MeanMonth<-data.frame(d2017MeanMonth) #データフレーム型にできる
  
# 2016-2019年の月別平均，最高，最低気温と降水量
dAllMonth <-dClimate %>%
    dplyr::group_by(Month) %>%
    dplyr::summarise(Mean=mean(na.omit(Mean)), Max=mean(na.omit(Max)), Min=mean(na.omit(Min)), Prec=sum(na.omit(Prec)))

##データの書き出し
write.table(dAllMonth, file="Climate.csv", sep=",", row.names=F)
```

## 解析に使う: 出穂期予測(モデリング)  
```R  
HD<-function(Yr, PM,PD) {
    One<-dClimate %>%dplyr::filter(Year==Yr) #該当年を切り出し
    ST <- which(One$Month==PM&One$Day==PD)
    PI<-0
    for (i in ST:300) {
        M<-One$Month[i]
        D<-One$Day[i]
        ET<-One$Mean[i]-10
        if (PI<=495) {
            EET<-max(min(ET,14),0)
            } else {
            EET<-max(ET,0)
            }
        PI<-PI+EET
        if (PI>=805) break
        }
    print(c(M,D))
}
```  


# より複雑な図
## それなりの図
- 手書きに近い  
  
```R  
d1<-read.table("Test1.txt", header=T)
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  
```
  
```R
plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,1),  # x軸の境界
        ylim = c(0,0.5), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "red",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.2,0.4,0.6,0.8,1.0), cex.axis=1.2, las=1, labels = T) # x軸目盛
axis(2, at=c(0,0.1,0.2,0.3,0.4,0.5), cex.axis=1.2, las=1, labels = T) # y軸目盛
mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5) # x軸ラベル
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5) #y軸ラベル
box("plot",lty=1,lwd=1) # 枠をつける
```  
  
## 図を重ねる
```R  
plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "red",
        pch=16,
        cex=2,
        axes=F,
    )
par(new=TRUE) # デフォルトはFalseなので図は更新される
plot(sd8$SDW,sd8$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "blue",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5)
box("plot",lty=1,lwd=1) # 枠をつける
```  

## 並べる

```R  
par(mfrow=c(1,2)) # c(行, 列)  
# 1つめ
plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,1.2),  # x軸の境界
        ylim = c(0,0.6), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "red",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # X軸ラベル
axis(2, at=c(0,0.2,0.4,0.6), cex.axis=1.2, las=1, labels = T) # y軸ラベル
mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5)
box("plot",lty=1,lwd=1) # 枠をつける

# 2つめ
plot(sd8$SDW,sd8$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "blue",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5)
box("plot",lty=1,lwd=1) # 枠をつける
```  

## 並べ方をモダンに  
```R  
par(oma = c(2, 2, 2, 2)) # 下・左・上・右
par(mfrow=c(1,2)) # c(行, 列)  
par(mar = c(5, 5, 0, 0))  # 下・左・上・右
plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "red",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
# mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 4)
box("plot",lty=1,lwd=1) # 枠をつける

par(mar = c(5, 0, 0, 5))  # 下・左・上・右
plot(sd8$SDW,sd8$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "blue",
        pch=16,
        cex=2,
        axes=F,
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
# axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
# mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
# mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5)
box("plot",lty=1,lwd=1) # 枠をつける
mtext("ShootDW",adj=0.5,side = 1, cex = 1.5, line = -1, outer=TRUE)

```  

# 図をpdfで書き出す  
## 基本
```R  
pdf("test.pdf", width=5, height=5)
a<-c(1,3,5,6,12)
b<-c(2,7,3,16,11)
plot(a,b,
        type="o",
        col="red",
        pch=16,
        cex=2,
    )
dev.off()
```  

## 実際のデータ
```R  
d1<-read.table("Test1.txt", header=T)
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  

pdf("Fig.pdf", width=10, height=5)
par(oma = c(2, 2, 2, 2)) # 下・左・上・右
par(mfrow=c(1,2)) # c(行, 列)  
par(mar = c(5, 5, 0, 0))  # 下・左・上・右

#1つめ
plot(sd5$SDW,sd5$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "red",
        pch=16,
        cex=2,
        axes=FALSE
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
# mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 4)
box("plot",lty=1,lwd=1) # 枠をつける

#2つめ
par(mar = c(5, 0, 0, 5))  # 下・左・上・右
plot(sd8$SDW,sd8$RDW, 
        xlim = c(0,2.4),  # x軸の境界
        ylim = c(0,1.2), # y軸の境界
        xlab = "", # x軸ラベル
        ylab = "", # y軸ラベル
        col = "blue",
        pch=16,
        cex=2,
        axes=FALSE
    )
axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.2, las=1, labels = T) # X軸ラベル
# axis(2, at=c(0,0.3,0.6,0.9,1.2), cex.axis=1.2, las=1, labels = T) # y軸ラベル
# mtext(1, text="ShootDW", adj=0.5, cex = 1.5, line = 2.5)
# mtext(2, text="RootDW", adj=0.5, cex = 1.5, line = 2.5)
box("plot",lty=1,lwd=1) # 枠をつける
mtext("ShootDW",adj=0.5,side = 1, cex = 1.5, line = -1, outer=TRUE)
dev.off()
```  

# コードはソースとして読むこともできる
```R  
source("Fig1.r")
source("Fig2.r")
source("Fig2long.r") #結果はFig2に同じ
```  

- [Fig1](https://github.com/blukaniro/RonFridays2020/blob/master/Fig1.pdf)
- [Fig2](https://github.com/blukaniro/RonFridays2020/blob/master/Fig2.pdf)
- [Fig1コード](https://github.com/blukaniro/RonFridays2020/blob/master/Fig1.r)
- [Fig2コード](https://github.com/blukaniro/RonFridays2020/blob/master/Fig2.r)
- [for, ifを使わないFig2コード](https://github.com/blukaniro/RonFridays2020/blob/master/Fig2long.r)

### 一応おしまい  
