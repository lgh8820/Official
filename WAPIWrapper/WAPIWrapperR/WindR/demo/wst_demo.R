# w.wst+w.wss demo
# Honghai Zhu 2013
#

require(WindR)

#user should start WindR firstly.
w.start(showmenu=FALSE);

code<-"000001.SH";#IF1306.CFE";#600004.SH"
begintime<-format(Sys.time(),"%Y%m%d 09:30:00");
endtime  <-format(Sys.time(),"%Y%m%d 15:00:00");

wst_data<- w.wst(code,"open,high,low,last",begintime,endtime)
if(wst_data$ErrorCode[[1]]!=0)
{
  error("w.wsd error")
}

data<-wst_data$Data;

getnamebycode<-function(code)
{
  data<-w.wss(code,"sec_name")
  if(data$ErrorCode==0)
    return (as.character(data$Data$SEC_NAME[[1]]))
  else
    return (NULL)
}

getPriceColor<-function(v,vbase)
{
  return(ifelse(v>vbase+0.000001,"red",ifelse(v<vbase-0.000001,"#00FFFF","#AAAAAA")))
  #if(v>gStockData$RT_PRE_CLOSE+0.00001)  return("red")
  #if(v<gStockData$RT_PRE_CLOSE-0.00001)  return("green")
  #
  #return("white")
}

x<-list()
x$length <- NROW(data)
x$xrange <- c(1,x$length)
x$spacing<- 1
Opens<-data$open
Closes<-data$last
Lows<-data$low
Highs<-data$high
x$name<-getnamebycode(code)
x$yrange <- c(min(Lows,na.rm=TRUE),max(Highs,na.rm=TRUE))
x.pos <- 1+x$spacing*(1:x$length-1)

# create scale of main plot window
par(bg="black",fg="white",col="white")
plot.new()
plot.window(xlim=c(1,x$xrange[2]*x$spacing),
            ylim=c(x$yrange[1],x$yrange[2]),
            )
#plot(c(0,400),c(0,500),xlab="",ylab="",xaxt="n",yaxt="n",type="n",asp=1,xaxs="i",yaxs="i")  

coords <- par('usr')
rect(coords[1],coords[3],coords[2],coords[4],col="black")
abline(h=axTicks(2), col="#800000")

#segments(x.pos,Lows,x.pos,Highs,col=getPriceColor(Closes,Opens))
#rect(x.pos-x$spacing/3,Opens,x.pos+x$spacing/3,Closes,
#     border=getPriceColor(Closes,Opens),col=getPriceColor(Closes,Opens))
#par(col.sub="white").
lines(x.pos,Closes,col="white")
title(x$name,col.main="white",sub="demo for wst",col.sub="white")

minv<-x.pos[1];maxv=x$length;
axpos<-axTicks(1)
labels<-rep("",length(axpos))
for( i in 1:length(axpos))
{
  if(axpos[i]>=minv && axpos[i]<=maxv)
  {
    labels[i]<-format(data$DATETIME[[axpos[i]]],"%d %H:%M:%S")
  }
}
axis(1,at=axTicks(1),labels=labels,col="white",col.axis="white")
axis(2,at=axTicks(2),labels=axTicks(2),col="white",col.axis="white",las=1)
axis(4,at=axTicks(2),labels=axTicks(2),col="white",col.axis="white",las=1)
#legend("topleft",legend="hello",text.col="white")
