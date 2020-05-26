R on Fridays 2020 by Ryosuke TAJIMA 
==============  
  
# 基本
## R言語の基本的な操作
```R  
x<-2
y<-5
z<-rbind(x,y) #行で結合
v<-cbind(x,y) #列で結合
a<-c(1,3,5,7,9) #数字列
b<-c(2,4,6,8,10) #数字列
b<-c(3,6,9,12,15) #後から入れたものに更新される
c<-rbind(a,b) #行で結合
d<-cbind(a,b) #列で結合
e<-a+b #要素の足し算
f<-a*b #要素の掛け算
moji<-c("A","B","C","D") # 文字列も要素になる
length(a) #数列の長さを計算
length(moji) #数列の長さを計算
```

## 数列生成
```R  
i <- seq(1, 40, by=1) # 1つずつ
j <- seq(1,40, by=2) # 奇数のみ39まで
i2 <- rep(i,2)
i2each <- rep(i,each=2)
# こんな使い方も
i3 <- rep(i,x)
i3each <- rep(i,each=y)
```  

## ディレクトリ
```R  
# ディレクトリの確認  
getwd()  
# ディレクトリの変更  
setwd()  
```  
あるいはGUIで
-  File > Change Directory ...  

## データの読み込み  
```R  
# txtファイル
d1<-read.table("Test1.txt", header=T) #txtはheaderがデフォルトでFalse
d1txt<-read.table("Test1.txt", header=T) #txtはheaderがデフォルトでFalse
d1txt  
# csvファイル
d1csv<-read.csv("Test1.csv") #csvはheaderがデフォルトでTrue
# 読み込んだデータのチェック
d1txt  
d1csv  
d1
head(d1)
nrow(d1) # 行数
ncol(d1) # 列数
dim(d1) #　行列数
```  
  
## クラス
```R  
class(d1$Stage)  
class(d1$Rep)  
class(d1$SDW)  
# numeric -> 数値，factor -> ファクター，character -> 文字列など
```  

## データセットの一部を抽出・利用  
```R  
A<-d1[1,1]
A<-d1[10,1]  
A<-d1[1:3,4:7]  
A<-d1[3,]  
A<-d1[,8]  
A<-d1[1:4,]  
A<-d1[,1:4]  
```  

## headerを使った抽出  
```R  
Stage<-d1$Stage  
Stage<-d1$stage # null, 大文字と小文字は区別される
```  
  
## subsetを使った抽出
```R  
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  
```  
- データが多い場合はdplyrを使うと早い  

## データの追加
```R  
# 換算値を足す
SRratio<-d1$SDW/d1$RDW # 地上部地下部比
SRL<-d1$RLD/d1$RDW # 比根長
d2<-cbind(d1,SRratio, SRL)
```  

## ファクターを足す
```R  
Lavels<-c("A", "A", "A", "A", "B", "B", "B", "B", "C", "C", "C", "C", "D", "D", "D", "D", "A", "A", "A", "A", "B", "B", "B", "B", "C", "C", "C", "C", "D", "D", "D", "D")
# でも良いが
moji<-c("A","B","C","D")
Lavels<-rep(rep(moji,each=4),2)
d2<-cbind(d1,SRratio, SRL, Lavels)
```  
  
##dplyr
```R  
library(dplyr)
dp1 <-d1 %>%
    dplyr::filter(d1$Stage == "5week")
```  

##データの換算値の付け足しも簡単  
```R  
dp2 <-d1 %>%
    dplyr::mutate(
        SRratio=d1$SDW/d1$RDW,
        SP=d1$SDW*d1$SPC/100*1000,
        SRL=d1$RLD/d1$RDW
        )
```  

## データのアウトラインを相関図で確認する  
```R  
plot(d1[,5:8])  
plot(d1[,6], d1[,7])
plot(d1$SDW, d1$RDW)
# 2つ選んで並べる  
par(mfrow=c(1,2)) # c(行, 列)  
plot(d1[,6], d1[,7])  
plot(d1$SDW, d1$RDW)  
par(mfcol=c(1,2)) # 並べ方を変えられるがここでは同じ図になる
plot(d1[,6], d1[,7])  
plot(d1$SDW, d1$RDW)  
```  

## 図示大事  
[Anscombe's_quartet](https://en.wikipedia.org/wiki/Anscombe%27s_quartet)  

## 箱ひげ図  
```R  
boxplot(d1$SDW)  
boxplot(sd5$SDW, sd8$SDW)  
boxplot(sd5$SDW~sd5$Limitation)  
boxplot(sd5$SDW~sd5$Inoculation)  
par(mfrow=c(1,2))
boxplot(sd5$SDW~sd5$Limitation)  
boxplot(sd8$SDW~sd8$Limitation)  
```  

## corrplotを使って  
```R  
cor_num<-cor(d1[,5:8])
library(corrplot)
corrplot.mixed(cor_num,lower="number",upper='ellipse')
```  

# 統計解析  
## Fisher 1966  
- If the design of an experiment is faulty, any method of interpretation which makes it out to be decisive must be faulty, too.  
  
## Fisherの3原則  
- 反復：実験ごとのばらつきを考慮するため同条件で複数回実験する  
- 局所管理：反復(ブロック)内では解析する要因以外の制御可能な要因は一定にする  
- 無作為化：制御できない要因はランダムになるようにする(系統誤差をなくす)  

## 一元配置の分散分析  
```R  
result<-aov(SDW~Limitation, sd5)  
summary(result)  
```  
  
## 二元配置の分散分析  
```R  
result<-aov(SDW~Limitation+Inoculation+Limitation*Inoculation, sd5)  
summary(result)  
result<-aov(SDW~Limitation*Inoculation, sd5) # 省略記法  
summary(result)  
```  
  
### 三元配置の分散分析  
```R  
result<-aov(SDW~Stage*Limitation*Inoculation, d1) #short version  
summary(result)  
```  

## 乱塊法
```R  
result<-aov(SDW~Rep+Limitation*Inoculation, sd5)
summary(result)  
```  
  
## 分割区法
```R  
result<-aov(SDW~Rep+Limitation+Error(Rep/Limitation)+Inoculation+Limitation*Inoculation, sd5)   
summary(result)  
```  
  
## 二方分割法
```R  
result<-aov(SDW~Rep+Limitation+Inoculation+Error(Rep/(Limitation*Inoculation))+Limitation*Inoculation, sd5)   
summary(result)  
```  

### 一度にまとめておこなえる  
```R  
# 5week  
summary(aov(SDW~Limitation*Inoculation, sd5))  
summary(aov(RDW~Limitation*Inoculation, sd5))  
summary(aov(SPC~Limitation*Inoculation, sd5))  
summary(aov(RLD~Limitation*Inoculation, sd5))  
  
# 8week  
summary(aov(SDW~Limitation*Inoculation, sd8))  
summary(aov(RDW~Limitation*Inoculation, sd8))  
summary(aov(SPC~Limitation*Inoculation, sd8))  
summary(aov(RLD~Limitation*Inoculation, sd8))  
```  
  
## TukeyHSDによる多重比較  
```R  
sd25<-subset(d2,d2$Stage=="5week")  #データの切り分け
sd28<-subset(d2,d2$Stage=="8week")  
result<-aov(SDW~Lavels, sd25) # 一元配置の分散分析
summary(result)  
TukeyHSD(result)  
```  
  
## multcomp利用，TukeyHSD  
```R  
library(multcomp)
result<-aov(SDW~Lavels, sd25) # 一元配置の分散分析
Tukey<-glht(result, linfct=mcp(Lavels="Tukey"))  
summary(Tukey)  
cld(Tukey, level = 0.05, decreasing = TRUE) # アルファベットをつける
```  

## multcomp利用，Dunnett  
```R  
library(multcomp)
result<-aov(SDW~Lavels, sd25) # 一元配置の分散分析
Dunnett<-glht(result, linfct=mcp(Lavels="Dunnett"))  
summary(Dunnett)  
```  
  
## 相関  
```R  
cor(sd5$SDW, sd5$SPC)  
allcor<-cor(sd5[,5:8]) #まとめて解析  
allcor
```  
  
## 回帰分析
```R  
result<-lm(SDW~SPC, sd5)  
summary(result)  
```  
  
## 重回帰分析
```R  
allcor # 事前に多重共線性のチェック
result<-lm(SDW~SPC+RLD, sd5)  
summary(result)  
```  

## 非線形回帰  
```R  
d3<-read.table("Test2.txt", header=T)  
x<-d3$Time
y<-d3$Rootlength
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
  
### 作図編，プログラミング編に続く・・・かもしれない