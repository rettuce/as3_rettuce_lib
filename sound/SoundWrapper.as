package com.rettuce.sound
{	
	import flash.display.*;
	import flash.events.*;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	public class SoundWrapper {
		
		public var vol:int = 100;
		private var tmpvol:int;
		private var tarvol:int;
		private var sound:Sound
		private var channel:SoundChannel;
		private var trans:SoundTransform = new SoundTransform;
		private var myTimer:Timer;
		private var Tcounter:int;
		
		public function SoundWrapper(S:Sound):void{
			sound = S;
		}
		
		public function setvol(k:int):void{
			vol = k;
			if (channel != null){
				trans.volume =  k/100;
				channel.soundTransform = trans;
				if(k == 0){
					stopSound();
				}
			}
		}
		
		public function playSound():void{
			trans.volume = vol/100;
			channel  = sound.play(0,1,trans);
		}
		
		public function loopSound(k:int):void{
			trans.volume = vol/100;
			if(k == 0){
				k = 9999
			}
			channel  = sound.play(0,k,trans);
		}
		
		public function stopSound():void{
			if (channel != null){
				channel.stop();
			}
		}
		
		public function fade(tvol:int,k:int):void {
			if (channel != null){
				tarvol= tvol;
				tmpvol = vol;
				Tcounter = 0;
				myTimer = new Timer(k*1000/30,30);
				myTimer.addEventListener("timer", timerHandler);
				myTimer.addEventListener("timerComplete", timerHandler2);
				myTimer.start();
			}
		}
		
		public function timerHandler2(e:TimerEvent):void{
			setvol(tarvol);
		}
		
		public function timerHandler(e:TimerEvent):void{
			Tcounter++;
			tmpvol =Tcounter/30*(tarvol - vol)+vol;
//			trace(tmpvol);
			trans.volume =  tmpvol/100;
			channel.soundTransform = trans;
		}
	}
}