d1<-read.table("Test1.txt", header=T) 

pdf("Fig2.pdf", width=10, height=12)
par(oma = c(10, 10, 10, 10)) # 下・左・上・右
par(mfcol=c(3,2)) # c(行, 列)  
par(mar = c(0, 0, 0, 0))  # 下・左・上・右

week<-c("5week", "8week")
cols<-c("red", "blue")
text2<-c("RootDW", "Phosphorus", "RLD")
text3<-c("5 week", "8 week")

ylims<-rbind(c(0,1.2), c(0,0.3), c(0,24)) # RDW, P, RLDの順
yaxes<-rbind(c(0,0.3,0.6,0.9,1.2), c(0,0.1,0.2,0.3,0.4), c(0,6,12,18,24)) # RDW, P, RLDの順

for (i in 1:2) {
    for (j in 1:3) {
        sd<-subset(d1,d1$Stage==week[i])
        x<-sd[,5]
        y<-sd[,5+j]
        plot(x,y, 
                xlim = c(0,2.4),  # x軸の境界
                ylim = ylims[j,1:2], # y軸の境界
                xlab = "", # x軸ラベル
                ylab = "", # y軸ラベル
                col = cols[i],
                pch=16,
                cex=2,
                axes=F,
            )
        if (i==1) {
            axis(2, at=yaxes[j,1:5], cex.axis=1.5, las=1, labels = T) # y軸ラベル
            mtext(2, text=text2[j], adj=0.5, cex = 1.5, line = 4)
            }
        if (j==1) {
            mtext(3, text=text3[i], adj=0.5, cex = 1.5, line = 1)
            }
        box("plot",lty=1,lwd=1) # 枠をつける
        }
        axis(1, at=c(0,0.6,1.2,1.8,2.4), cex.axis=1.5, las=1, labels = T) # x軸ラベル
    }
mtext("ShootDW",adj=0.5,side = 1, cex = 1.5, line = 4, outer=TRUE)
dev.off()
