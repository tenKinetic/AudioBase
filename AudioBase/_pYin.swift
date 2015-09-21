//
//  pYin.swift
//  AudioBase
//
//  Created by Chris Saunders on 3/09/2015.
//  Copyright (c) 2015 tenKinetic. All rights reserved.
//

import Foundation

typealias FrequencyClosure = (YinOutput) -> Void

struct YinOutput
{
    var f0:Double
    var periodicity:Double
    var rms:Double
    var salience = [Double]()
    var freqProb = [Probability]()
    
    init()
    {
        self.f0 = 0
        self.periodicity = 0
        self.rms = 0
    }
    
    init(f:Double, p:Double, r:Double)
    {
        self.f0 = f
        self.periodicity = p
        self.rms = r
    }
    
    init(f:Double, p:Double, r:Double, salience:[Double])
    {
        self.f0 = f
        self.periodicity = p
        self.rms = r
        self.salience = salience
    }
}

struct Probability
{
    var frequency:Double
    var probability:Double
}

class pYin
{
    let uniformDist:[Double] = [0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000,0.0100000]
    let betaDist1:[Double] = [0.028911,0.048656,0.061306,0.068539,0.071703,0.071877,0.069915,0.066489,0.062117,0.057199,0.052034,0.046844,0.041786,0.036971,0.032470,0.028323,0.024549,0.021153,0.018124,0.015446,0.013096,0.011048,0.009275,0.007750,0.006445,0.005336,0.004397,0.003606,0.002945,0.002394,0.001937,0.001560,0.001250,0.000998,0.000792,0.000626,0.000492,0.000385,0.000300,0.000232,0.000179,0.000137,0.000104,0.000079,0.000060,0.000045,0.000033,0.000024,0.000018,0.000013,0.000009,0.000007,0.000005,0.000003,0.000002,0.000002,0.000001,0.000001,0.000001,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000]
    let betaDist2:[Double] = [0.012614,0.022715,0.030646,0.036712,0.041184,0.044301,0.046277,0.047298,0.047528,0.047110,0.046171,0.044817,0.043144,0.041231,0.039147,0.036950,0.034690,0.032406,0.030133,0.027898,0.025722,0.023624,0.021614,0.019704,0.017900,0.016205,0.014621,0.013148,0.011785,0.010530,0.009377,0.008324,0.007366,0.006497,0.005712,0.005005,0.004372,0.003806,0.003302,0.002855,0.002460,0.002112,0.001806,0.001539,0.001307,0.001105,0.000931,0.000781,0.000652,0.000542,0.000449,0.000370,0.000303,0.000247,0.000201,0.000162,0.000130,0.000104,0.000082,0.000065,0.000051,0.000039,0.000030,0.000023,0.000018,0.000013,0.000010,0.000007,0.000005,0.000004,0.000003,0.000002,0.000001,0.000001,0.000001,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000]
    let betaDist3:[Double] = [0.006715,0.012509,0.017463,0.021655,0.025155,0.028031,0.030344,0.032151,0.033506,0.034458,0.035052,0.035331,0.035332,0.035092,0.034643,0.034015,0.033234,0.032327,0.031314,0.030217,0.029054,0.027841,0.026592,0.025322,0.024042,0.022761,0.021489,0.020234,0.019002,0.017799,0.016630,0.015499,0.014409,0.013362,0.012361,0.011407,0.010500,0.009641,0.008830,0.008067,0.007351,0.006681,0.006056,0.005475,0.004936,0.004437,0.003978,0.003555,0.003168,0.002814,0.002492,0.002199,0.001934,0.001695,0.001481,0.001288,0.001116,0.000963,0.000828,0.000708,0.000603,0.000511,0.000431,0.000361,0.000301,0.000250,0.000206,0.000168,0.000137,0.000110,0.000088,0.000070,0.000055,0.000043,0.000033,0.000025,0.000019,0.000014,0.000010,0.000007,0.000005,0.000004,0.000002,0.000002,0.000001,0.000001,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000]
    let betaDist4:[Double] = [0.003996,0.007596,0.010824,0.013703,0.016255,0.018501,0.020460,0.022153,0.023597,0.024809,0.025807,0.026607,0.027223,0.027671,0.027963,0.028114,0.028135,0.028038,0.027834,0.027535,0.027149,0.026687,0.026157,0.025567,0.024926,0.024240,0.023517,0.022763,0.021983,0.021184,0.020371,0.019548,0.018719,0.017890,0.017062,0.016241,0.015428,0.014627,0.013839,0.013068,0.012315,0.011582,0.010870,0.010181,0.009515,0.008874,0.008258,0.007668,0.007103,0.006565,0.006053,0.005567,0.005107,0.004673,0.004264,0.003880,0.003521,0.003185,0.002872,0.002581,0.002312,0.002064,0.001835,0.001626,0.001434,0.001260,0.001102,0.000959,0.000830,0.000715,0.000612,0.000521,0.000440,0.000369,0.000308,0.000254,0.000208,0.000169,0.000136,0.000108,0.000084,0.000065,0.000050,0.000037,0.000027,0.000019,0.000014,0.000009,0.000006,0.000004,0.000002,0.000001,0.000001,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000]
    let single10:[Double] = [0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,1.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000]
    let single15:[Double] = [0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,1.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000]
    let single20:[Double] = [0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,1.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000,0.00000]

    let frameSize:UInt64!
    let sampleRate:UInt64!
    let threshold:Double!
    let thresholdDistribution:UInt64!
    let yinBufferSize:UInt64!
    var fast = true
    
    let initialised = false

    init (frameSize: UInt64, inputSampleRate:UInt64, thresh:Double = 0.2, fast:Bool = true)
    {
        self.frameSize = frameSize
        self.sampleRate = inputSampleRate
        self.threshold = thresh
        self.thresholdDistribution = 2
        self.yinBufferSize = frameSize/2
        self.fast = fast
        
        if !((frameSize & (frameSize-1)) != 0)
        {
            initialised = true
        }
        else
        {
            println("frame size must be a power of 2")
        }
    }
    
    func analyse(data:UnsafePointer<UnsafeMutablePointer<Float>>, frequencyClosure:FrequencyClosure)
    {
        //frequencyClosure(0,0)
        
        var yinBuffer = [Double]()
        
        // calculate aperiodicity function for all periods
        if (self.fast)
        {
            fastDifference(data, yinBuffer: &yinBuffer, yinBufferSize: self.yinBufferSize)
        }
        else
        {
            slowDifference(data, yinBuffer: &yinBuffer, yinBufferSize: self.yinBufferSize)
        }
        
        cumulativeDifference(&yinBuffer, yinBufferSize: self.yinBufferSize)
        
        let peakProbability:[Double] = yinProb(&yinBuffer,prior:  self.thresholdDistribution,yinBufferSize:  self.yinBufferSize)
        
        // calculate overall "probability" from peak probability
        var probSum:Double = 0
        for (var iBin:UInt64 = 0; iBin < self.yinBufferSize; ++iBin)
        {
            probSum += peakProbability[Int(iBin)]
        }
        let sumSq = sumSquare(data, start: 0, end: self.yinBufferSize) / Double(self.yinBufferSize)
        let rms:Double = sqrt(sumSq)
        
        var yo = YinOutput(f: 0,p: 0,r: rms)
        
        for (var iBuf:UInt64 = 0; iBuf < self.yinBufferSize; ++iBuf)
        {
            yo.salience.append(peakProbability[Int(iBuf)])
            if (peakProbability[Int(iBuf)] > 0)
            {
                let pi = parabolicInterpolation(yinBuffer, tau: iBuf, yinBufferSize: self.yinBufferSize)
                let invPi = 1.0 / pi
                let currentF0:Double = Double(self.sampleRate) * invPi
                yo.freqProb.append(Probability(frequency: currentF0, probability: peakProbability[Int(iBuf)]))
            }
        }
        
        //return yo
        frequencyClosure(yo)
    }
    
    func slowDifference(data:UnsafePointer<UnsafeMutablePointer<Float>>, inout yinBuffer:[Double], yinBufferSize:UInt64)
    {
        yinBuffer[0] = 0
        var delta:Double
        var startPoint:Int = 0
        var endPoint:Int = 0
        for (var i:Int = 1; i < Int(yinBufferSize); ++i)
        {
            yinBuffer[i] = 0
            startPoint = Int(yinBufferSize)/2 - i/2
            endPoint = startPoint + Int(yinBufferSize)
            for (var j:Int = startPoint; j < endPoint; ++j)
            {
                delta = Double(data.memory[i+j] - data.memory[j])
                yinBuffer[i] += delta * delta;
            }
        }
    }
    
    func fastDifference(data:UnsafePointer<UnsafeMutablePointer<Float>>, inout yinBuffer:[Double], yinBufferSize:UInt64)
    {
        // DECLARE AND INITIALISE
        let frameSize:Int = 2 * Int(yinBufferSize)
        
        var audioTransformedReal:[Double]? = [Double](count:frameSize, repeatedValue:0)
        var audioTransformedImag:[Double]? = [Double](count:frameSize, repeatedValue:0)
        var nullImag = [Double](count:frameSize, repeatedValue:0)
        var kernel = [Double](count:frameSize, repeatedValue:0)
        var kernelTransformedReal:[Double]? = [Double](count:frameSize, repeatedValue:0)
        var kernelTransformedImag:[Double]? = [Double](count:frameSize, repeatedValue:0)
        var yinStyleACFReal = [Double](count:frameSize, repeatedValue:0)
        var yinStyleACFImag = [Double](count:frameSize, repeatedValue:0)
        var powerTerms = [Double](count:Int(yinBufferSize), repeatedValue:0)
        yinBuffer = [Double](count:Int(yinBufferSize), repeatedValue:0)
        
        // POWER TERM CALCULATION
        // ... for the power terms in equation (7) in the Yin paper
        powerTerms[0] = 0.0
        for (var j:Int = 0; j < Int(yinBufferSize); ++j)
        {
            powerTerms[0] += Double(data.memory[j] * data.memory[j])
        }
        
        // now iteratively calculate all others (saves a few multiplications)
        for (var tau:Int = 1; tau < Int(yinBufferSize); ++tau)
        {
            powerTerms[tau] = Double(powerTerms[tau-1]) - Double(data.memory[tau-1]) * Double(data.memory[tau-1]) +
                Double(data.memory[tau+Int(yinBufferSize)]) * Double(data.memory[tau+Int(yinBufferSize)])
        }
        
        // YIN-STYLE AUTOCORRELATION via FFT
        // 1. data
        fft(UInt(frameSize), inverse: false, ri: data, ii: nullImag, ro: &audioTransformedReal, io: &audioTransformedImag)
        
        // 2. half of the data, disguised as a convolution kernel
        for (var j:UInt64 = 0; j < yinBufferSize; ++j)
        {
            kernel[Int(j)] = Double(data.memory[yinBufferSize-1-j])
        }
        fft(UInt(frameSize), inverse: false, ri: UnsafePointer<UnsafeMutablePointer<Float>>(kernel), ii: nullImag, ro: &kernelTransformedReal, io: &kernelTransformedImag)
        
        // 3. convolution via complex multiplication -- written into
        for (var j = 0; j < frameSize; ++j)
        {
            yinStyleACFReal[j] = audioTransformedReal![j]*kernelTransformedReal![j] - audioTransformedImag![j]*kernelTransformedImag![j]; // real
            yinStyleACFImag[j] = audioTransformedReal![j]*kernelTransformedImag![j] + audioTransformedImag![j]*kernelTransformedReal![j]; // imaginary
        }
        fft(UInt(frameSize), inverse: true, ri: UnsafePointer<UnsafeMutablePointer<Float>>(yinStyleACFReal), ii: yinStyleACFImag, ro: &audioTransformedReal, io: &audioTransformedImag)
        
        // CALCULATION OF difference function
        // ... according to (7) in the Yin paper.
        for (var j:UInt64 = 0; j < yinBufferSize; ++j)
        {
            // taking only the real part
            yinBuffer[Int(j)] = powerTerms[0] + powerTerms[Int(j)] - 2 * audioTransformedReal![j+yinBufferSize-1];
        }
    }
    
    func cumulativeDifference(inout yinBuffer:[Double], yinBufferSize:UInt64)
    {
        var tau:UInt64
        yinBuffer[0] = 1
        var runningSum:Double = 0
        
        for (tau = 1; tau < yinBufferSize; ++tau)
        {
            runningSum += yinBuffer[Int(tau)]
            if (runningSum == 0)
            {
                yinBuffer[Int(tau)] = 1;
            }
            else
            {
                yinBuffer[Int(tau)] *= Double(tau) / runningSum
            }
        }
    }
    
    func yinProb(inout yinBuffer:[Double], prior:UInt64, yinBufferSize:UInt64, minTau0:UInt64 = 0, maxTau0:UInt64 = 0) -> [Double]
    {
        var minTau:UInt64 = 2;
        var maxTau = yinBufferSize;
        
        // adapt period range, if necessary
        if (minTau0 > 0 && minTau0 < maxTau0)
        {
            minTau = minTau0
        }
        if (maxTau0 > 0 && maxTau0 < yinBufferSize && maxTau0 > minTau)
        {
            maxTau = maxTau0
        }
        
        var minWeight:Double = 0.01;
        var tau:UInt64 = 0
        var thresholds = [Double]()
        var distribution = [Double]()
        var peakProb = [Double](count:Int(yinBufferSize), repeatedValue:0)
        
        var nThreshold:UInt64 = 100
        var nThresholdInt = Int(nThreshold)
        
        for (var i:Int = 0; i < nThresholdInt; ++i)
        {
            switch (prior) {
            case 0:
                distribution.append(uniformDist[i])
                break;
            case 1:
                distribution.append(betaDist1[i])
                break;
            case 2:
                distribution.append(betaDist2[i])
                break;
            case 3:
                distribution.append(betaDist3[i])
                break;
            case 4:
                distribution.append(betaDist4[i])
                break;
            case 5:
                distribution.append(single10[i])
                break;
            case 6:
                distribution.append(single15[i])
                break;
            case 7:
                distribution.append(single20[i])
                break;
            default:
                distribution.append(uniformDist[i])
            }
            thresholds.append(0.01 + Double(i) * 0.01)
        }
        
        
        var currThreshInd:Int = nThreshold-1
        tau = minTau
        
        var minInd:UInt64 = 0
        var minVal:Double = 42
        var sumProb:Double = 0
        while (tau+1 < maxTau)
        {
            let a = yinBuffer[Int(tau)]
            let b = thresholds[thresholds.count-1]
            let c = yinBuffer[Int(tau)+1]
            
            if a < b && c < a
            {
                while (tau + 1 < maxTau && c < a)
                {
                    tau++
                }
                // tau is now local minimum
                // std::cerr << tau << " " << currThreshInd << " "<< thresholds[currThreshInd] << " " << distribution[currThreshInd] << std::endl;
                if (a < minVal && tau > 2){
                    minVal = a
                    minInd = tau
                }
                currThreshInd = nThresholdInt-1;
                while (thresholds[currThreshInd] > a && currThreshInd > -1)
                {
                    // std::cerr << distribution[currThreshInd] << std::endl;
                    peakProb[Int(tau)] += distribution[currThreshInd]
                    currThreshInd--;
                }
                // peakProb[tau] = 1 - yinBuffer[tau];
                sumProb += peakProb[Int(tau)]
                tau++
            }
            else
            {
                tau++
            }
        }
        
        if (peakProb[Int(minInd)] > 1)
        {
            println("WARNING: yin has prob > 1 ??? I'm returning all zeros instead.")
            return [Double](count:Int(yinBufferSize), repeatedValue: 0)
        }
        
        var nonPeakProb:Double = 1
        if (sumProb > 0)
        {
            for (var i:UInt64 = minTau; i < maxTau; ++i)
            {
                peakProb[Int(i)] = peakProb[Int(i)] / sumProb * peakProb[Int(minInd)]
                nonPeakProb -= peakProb[Int(i)]
            }
        }
        if (minInd > 0)
        {
            // std::cerr << "min set " << minVal << " " << minInd << " " << nonPeakProb << std::endl;
            peakProb[Int(minInd)] += nonPeakProb * minWeight;
        }
        
        return peakProb;
    }
    
    func sumSquare(data:UnsafePointer<UnsafeMutablePointer<Float>>, start:UInt64, end:UInt64) -> Double
    {
        var out:Double = 0
        for var i:UInt64 = start; i < end; ++i
        {
            let square = data.memory[Int(i)] * data.memory[Int(i)] //data[Int(i)] * data[Int(i)]
            out += Double(square)
        }
        return out;
    }
    
    func parabolicInterpolation(yinBuffer:[Double], tau:UInt64, yinBufferSize:UInt64) -> Double
    {
        // this is taken almost literally from Joren Six's Java implementation
        if (tau == yinBufferSize) // not valid anyway.
        {
            return Double(tau)
        }
        
        var betterTau:Double = 0.0;
        if (tau > 0 && tau < yinBufferSize-1)
        {
            var s0:Double, s1:Double, s2:Double
            s0 = yinBuffer[tau-1];
            s1 = yinBuffer[Int(tau)];
            s2 = yinBuffer[Int(tau)+1];
            
            var adjustment:Double = (s2 - s0) / (2 * (2 * s1 - s2 - s0))
            
            if (abs(adjustment) > 1)
            {
                adjustment = 0
            }
            
            betterTau = Double(tau) + adjustment
        }
        else
        {
            // std::cerr << "WARNING: can't do interpolation at the edge (tau = " << tau << "), will return un-interpolated value.\n";
            betterTau = Double(tau)
        }
        return betterTau
    }
    
    func fft(n:UInt, inverse:Bool, ri:UnsafePointer<UnsafeMutablePointer<Float>>?, ii:[Double]?, inout ro:[Double]?, inout io:[Double]?)
    {
        if let ri = ri
        {
            if var _ro = ro
            {
                if var _io = io
                {
                    
                    var bits:UInt
                    var i:UInt
                    var j:UInt
                    var k:UInt
                    var m:UInt
                    var blockSize:UInt
                    var blockEnd:UInt
                    
                    var tr:Double
                    var ti:Double
                    
                    if (n < 2) { return }
                    if !((n & (n-1)) != 0) { return }
                    
                    var angle:Double = 2.0 * M_PI
                    if (inverse)
                    {
                        angle = -angle
                    }
                    
                    for (i = 0; ; ++i)
                    {
                        if !(n & (1 << i) != 0)
                        {
                            bits = i
                            break
                        }
                    }
                    
                    var table = [Int](count:Int(n), repeatedValue:0)
                    
                    for (i = 0; i < n; ++i)
                    {
                        m = i
                        k = 0
                        for (j = 0; j < bits; ++j)
                        {
                            k = (k << 1) | (m & 1)
                            m >>= 1
                        }
                        table[Int(i)] = Int(k)
                    }
                    
                    if let ii = ii
                    {
                        for (i = 0; i < n; ++i)
                        {
                            _ro[table[Int(i)]] = Double(ri.memory[Int(i)])
                            _io[table[Int(i)]] = ii[Int(i)]
                        }
                    }
                    else
                    {
                        for (i = 0; i < n; ++i)
                        {
                            _ro[table[Int(i)]] = Double(ri.memory[Int(i)])
                            _io[table[Int(i)]] = 0.0
                        }
                    }
                    
                    blockEnd = 1;
                    
                    for (blockSize = 2; blockSize <= n; blockSize <<= 1) {
                        
                        let delta = angle / Double(blockSize)
                        let sm2 = -sin(-2 * delta)
                        let sm1 = -sin(-delta)
                        let cm2 = cos(-2 * delta)
                        let cm1 = cos(-delta)
                        let w = 2 * cm1
                        var ar = [Double](count:3, repeatedValue:0)
                        var ai = [Double](count:3, repeatedValue:0)
                        
                        for (i = 0; i < n; i += blockSize)
                        {
                            ar[2] = cm2
                            ar[1] = cm1
                            
                            ai[2] = sm2
                            ai[1] = sm1
                            
                            for (j = i, m = 0; m < blockEnd; j++, m++)
                            {
                                ar[0] = w * ar[1] - ar[2]
                                ar[2] = ar[1]
                                ar[1] = ar[0]
                                
                                ai[0] = w * ai[1] - ai[2]
                                ai[2] = ai[1]
                                ai[1] = ai[0]
                                
                                k = j + blockEnd
                                tr = ar[0] * _ro[Int(k)] - ai[0] * _io[Int(k)]
                                ti = ar[0] * _io[Int(k)] + ai[0] * _ro[Int(k)]
                                
                                _ro[Int(k)] = _ro[Int(j)] - tr
                                _io[Int(k)] = _io[Int(j)] - ti
                                
                                _ro[Int(j)] += tr
                                _io[Int(j)] += ti
                            }
                        }
                        
                        blockEnd = blockSize
                    }
                    
                    if (inverse)
                    {
                        let denom = Double(n)
                        
                        for (i = 0; i < n; i++)
                        {
                            _ro[Int(i)] /= denom
                            _io[Int(i)] /= denom
                        }
                    }
                    
                    // keep the image data updated
                    io = _io
                }
                
                // keep the real data updated
                ro = _ro
            }
        }
    }
}




