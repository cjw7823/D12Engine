#pragma once

#include <chrono>

class GameTimer
{
	using clock = std::chrono::steady_clock;

public:
	GameTimer() { Reset(); }

	//애플리케이션 시작 이후 경과된 전체 시간(초)
	float TotalTime()const
	{
		auto elapsed = mStopped
			? (mStopTime - mBaseTime - mPausedDuration)
			: (mCurrTime - mBaseTime - mPausedDuration);

		return std::chrono::duration<float>(elapsed).count();
	}

	//이전 프레임 이후 경과된 시간(초)
	float DeltaTime()const { return static_cast<float>(mDeltaTime); }

	void Reset()
	{
		clock::time_point now = clock::now();

		mBaseTime = now;
		mPrevTime = now;
		mCurrTime = now;
		mStopTime = now;

		mDeltaTime = 0.0;
		mPausedDuration = clock::duration::zero();
		mStopped = false;
	}

	void Start()
	{
		if (mStopped)
		{
			auto now = clock::now();
			mPausedDuration += (now - mStopTime);
			mPrevTime = now;
			mStopTime = now;
			mStopped = false;
		}
	}

	void Stop()
	{
		if (!mStopped)
		{
			mStopTime = clock::now();
			mStopped = true;
		}
	}

	//매 프레임 호출
	void Tick()
	{
		if (mStopped)
		{
			mDeltaTime = 0.0;
			return;
		}

		mCurrTime = clock::now();
		mDeltaTime = std::chrono::duration<double>(mCurrTime - mPrevTime).count();
		mPrevTime = mCurrTime;

		//DXSDK의 CDXUTTimer에 따르면 프로세서가 절전 모드로 전환되거나 다른 프로세서로 전환될 경우
		//mDeltaTime이 음수가 될 수 있습니다. QPC에서는 발생 가능한 현상이나 chrono에서는 발생하지 않는 것 같습니다.
		if(mDeltaTime < 0.0)
			mDeltaTime = 0.0;
	}

private:
	double mDeltaTime;

	clock::time_point mBaseTime;
	clock::time_point mPrevTime;
	clock::time_point mCurrTime;
	clock::time_point mStopTime;
	clock::duration mPausedDuration; //nano초 단위

	bool mStopped;
};