d1<-read.table("Test1.txt", header=T)  
sd5<-subset(d1,d1$Stage=="5week")  
sd8<-subset(d1,d1$Stage=="8week")  

pdf("Fig1.pdf", width=10, height=5)  
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
dev.off()
