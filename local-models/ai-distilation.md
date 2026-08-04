---
category: deep-research ai-labs distilation revenue
logic:
  - 30% of the Revenue of USA AI Labs comes from distillation
  - China is the largest country distilling from US AI Labs
  - 30% of the Annual Run Rate of USA Frontier AI Labs (OpenAI and Anthropic) is coming from foreign Chinese counterparts that aim to distill the models
initial-overview:
  - https://www.youtube.com/live/AWt3IShB1eg?si=wGm2ZYXPDRkadVlM&t=8205
  - https://x.com/andrewho03/status/2082786931419812338
  - https://fortune.com/2026/07/30/former-openai-researcher-overvalued-lockup
opportunity-question: Sovereign and Locally Hosted Open Sourced AI
initial-gaugue: Exa-AI; Mistral; Perplexity
---

# EXA-AI Response:

Evidence supports a real China-linked gray-market and adversarial-distillation problem for OpenAI/Anthropic, but I found no reliable evidence that 30% of either company’s revenue comes from Chinese distillation accounts. The 30% claim should be treated as unproven and likely conflates usage/extraction risk with revenue quality.

**Bottom line:** There is strong evidence of China-linked adversarial distillation and gray-market access to OpenAI/Anthropic models, including proxy networks, fraudulent accounts, unauthorized resellers, and large-scale Claude/OpenAI extraction attempts. However, I found no credible source quantifying this as 30% of OpenAI or Anthropic revenue. The revenue-exposure thesis is plausible as a risk to analyze, but the specific 30% revenue-share claim is unsupported by the evidence gathered.

**Confidence calibration**

**Low confidence:** The specific assertion that 30% of OpenAI and Anthropic revenue comes from Chinese distillation-related subscribers/accounts. I found no source providing that number or enough data to infer it defensibly.

**High confidence:** China-linked distillation attempts and proxy access markets exist and are large enough to be taken seriously by Anthropic, OpenAI, and the White House.

**Medium confidence:** Some portion of US AI-lab paid usage likely flows through gray-market accounts or resellers serving Chinese users, and some of that usage may support distillation or post-training datasets.

**ARR and run rate caveat:** The user’s accounting concern is directionally valid: many private AI-lab revenue figures are annualized run-rate numbers, not audited annual recurring revenue. Sources describe OpenAI at roughly $24–25B annualized run-rate in 2026, derived from roughly $2B monthly revenue, and Anthropic around $30B annualized run-rate in April 2026. OfficeChai notes these are annualized run-rate figures rather than audited annual revenue and that OpenAI and Anthropic may report cloud-channel revenue differently: OpenAI net for some Azure sales, Anthropic gross for cloud marketplaces. This makes headline “ARR” comparisons noisy.

**Revenue claim assessment**

**Why:** The evidence shows large usage volumes, proxy markets, and fraudulent account networks, but not revenue attribution. Fraudulent accounts, free-credit abuse, stolen-card usage, account sharing, and reseller discounting may generate little or no durable recognized revenue for the labs, and can even produce chargebacks or cost leakage. Conversely, some proxy traffic may be paid API consumption, but no source quantified it as a share of OpenAI or Anthropic revenue.

**Finding:** Not substantiated.

**Claim tested:** 30% of OpenAI and/or Anthropic revenue is coming from Chinese accounts using subscriptions or APIs for distillation.

**What would be needed:** Provider billing data split by account provenance, reseller/router attribution, fraud/chargeback adjustments, token usage by suspected distillation clusters, and paid-versus-free/discounted account mix. Without those, the 30% number is a hypothesis, not an evidence-backed estimate.

**Investment risk implications**

- Revenue-quality risk: If some reported growth comes from gray-market or unauthorized usage, it may not be sticky, compliant, or collectible at normal gross margins.
- Cost-leakage risk: Distillation traffic can consume expensive inference capacity while enabling competitors to train cheaper substitutes, reducing future pricing power.
- Policy/enforcement risk: Tighter KYC, payment controls, router bans, regional restrictions, and inter-lab intelligence sharing could reduce some traffic that currently appears as demand.
- Competitive risk: Distilled or open-weight Chinese models such as DeepSeek/Qwen-style systems can compress the value of proprietary US APIs in the mid-market, especially for coding and agentic workflows.
- Accounting risk: Annualized run-rate figures can overstate durable recurring revenue if a recent month contains temporary, promotional, fraudulent, or non-recurring usage.

**Evidence for gray market access:** ChinaTalk documents a public Chinese gray-market of API proxies or “transfer stations” that let users in China access Claude and other US models despite regional, payment, and identity barriers. These services may use bulk accounts, discount arbitrage, account pooling, free credits, fraudulent/stolen cards, model swapping, and log harvesting. The report says some Claude tokens are sold at roughly 10% of official prices and that logs can become datasets useful for post-training or distillation. This supports the idea that Chinese demand can route through accounts that appear legitimate or non-Chinese to the model provider.

**Recommended follow up diligence**

- Ask labs or secondaries for revenue quality by channel: direct consumer subscriptions, direct API, cloud marketplace, enterprise contracts, resellers/routers, and suspicious/fraud-filtered accounts.
- Separate gross billings, net revenue, chargebacks, free credits, cloud-provider shares, and compute cost by channel.
- Measure suspected distillation clusters by paid revenue, token volume, gross margin, and churn after enforcement actions.
- Track Chinese open-weight adoption as a leading indicator of future API price compression.
- Watch policy actions on API routers, payment rails, KYC, cloud access, and export-control enforcement because these could suddenly reduce questionable traffic or raise compliance costs.

**Evidence for distillation activity**

| Claim | Source | Details |
| --- | --- | --- |
| Anthropic says DeepSeek, Moonshot, and MiniMax generated over 16 million Claude exchanges through about 24,000 fraudulent accounts, using commercial proxy services to bypass regional access restrictions. | Anthropic | Anthropic attributes over 150,000 exchanges to DeepSeek, over 3.4 million to Moonshot, and over 13 million to MiniMax, targeting agentic reasoning, tool use, coding, and orchestration. |
| OpenAI says most adversarial distillation activity it observes appears to originate from China, sometimes Russia, and that DeepSeek continues to use obfuscated methods including third-party routers and unauthorized resellers. | OpenAI memo to US House Select Committee | OpenAI says Chinese actors moved beyond chain-of-thought extraction toward multi-stage synthetic-data, cleaning, and reinforcement-style preference pipelines. |
| The White House stated that foreign entities, principally based in China, are engaged in deliberate, industrial-scale campaigns to distill US frontier AI systems using tens of thousands of proxy accounts. | White House / Reuters | Reuters also reported China’s embassy called the allegations baseless, so the geopolitical attribution remains contested even though US labs and US government sources are aligned on the threat framing. |

---

# Mistral Response (July 31, 2026)

## Executive Summary

The claim that 30% of OpenAI and Anthropic revenue derives from Chinese accounts using their services for model distillation requires careful scrutiny. While **direct evidence of a 30% revenue share from Chinese accounts is not publicly verifiable**, substantial evidence confirms that:

1. **Adversarial distillation by Chinese labs is massive and documented**: Anthropic reported **16 million flagged exchanges** from DeepSeek, Moonshot AI, and MiniMax, representing systematic model extraction at scale.
2. **Chinese developers access US models despite restrictions**: OpenAI's API is officially blocked in China, yet developers use VPNs, third-party proxies, and dedicated solutions like GitHub's `openai-proxy` to maintain access.
3. **The 30% figure likely conflates two different phenomena**:
  - US companies using Chinese models (confirmed at &gt;30% token share on OpenRouter)
  - Chinese accounts using US models for distillation (happening but not quantified at 30%)
4. **ARR calculation as MRR x 12 is standard but problematic**: This method, used by many SaaS companies, can significantly inflate revenue numbers for high-growth firms, as it annualizes the most recent month without accounting for churn or the non-representative nature of rapid growth periods.
5. **Revenue exposure risk is real**: If a significant portion of API revenue comes from accounts engaged in adversarial distillation, and these are suddenly blocked, it could create material revenue volatility.

**Assessment**: The specific 30% revenue claim lacks direct sourcing, but the underlying phenomena (Chinese distillation, US model access via proxies, ARR inflation) are all substantiated. The risk to AI lab valuations from these factors is credible and material.

## Research Question

Investigate the validity of the claim that 30% of OpenAI and Anthropic revenue originates from Chinese accounts using their services for model distillation, and analyze the implications of ARR being calculated as monthly revenue multiplied by 12.

## Methodology

### Search Strategy

1. **Primary Evidence on Distillation**: Searched for documented cases of Chinese labs extracting US model outputs, focusing on Anthropic and OpenAI disclosures.
2. **Revenue Composition**: Investigated OpenAI and Anthropic revenue breakdowns by region, product line, and customer type.
3. **ARR Calculation Standards**: Researched SaaS industry definitions and criticisms of ARR calculation methodologies.
4. **Access Patterns**: Examined how Chinese users access US AI services despite geographic restrictions.

### Source Types

- Industry analysis and reporting (Bloomberg, DecodeTheFuture, Yahoo Finance)
- Official company disclosures (OpenAI Signals, developer documentation)
- SaaS metrics standards (ChartMogul, SaaS Metrics Board, Maxio)
- Technical evidence (GitHub repositories, API documentation)
- Market data (OpenRouter usage statistics)

### Limitations

- OpenAI does not disclose revenue by country
- Direct quantification of Chinese account revenue share is not publicly available
- Some data points are estimates from third-party analysts

---

## Findings

### 1. Adversarial Distillation: Scale and Documentation

**Confirmed**: Chinese AI labs are systematically extracting outputs from US frontier models at massive scale.

**Key Evidence**:

- **Anthropic's Documentation**: The company has documented **approximately 16 million exchanges** traced to DeepSeek, Moonshot AI, and MiniMax that it classifies as adversarial distillation traffic. This represents the most concrete public quantification of the problem. [DecodeTheFuture, April 2026](https://decodethefuture.org/en/adversarial-distillation/)
- **Frontier Model Forum Cooperation**: OpenAI, Anthropic, and Google DeepMind have begun sharing threat intelligence through the Frontier Model Forum to detect and defend against adversarial distillation attempts. This is the first operational use of the Forum since its 2023 launch. [Bloomberg, April 6, 2026](https://www.bloomberg.com/news/articles/2026-04-06/openai-anthropic-google-unite-to-combat-model-copying-in-china)
- **Named Perpetrators**: OpenAI's memo to the House Select Committee on China accused DeepSeek of attempting to "free-ride on the capabilities developed by OpenAI and other US frontier labs." Moonshot AI and MiniMax were named by Anthropic in February 2026 disclosures.

**Economic Asymmetry**: US labs spend hundreds of billions on data centers, training runs, and safety research, then price APIs to recover costs. Chinese open-weight models are available at approximately **14x lower cost per token**. If distillation contributes to this cost gap, US labs pay a defensive tax their competitors do not. [DecodeTheFuture](https://decodethefuture.org/en/adversarial-distillation/)

### 2. Chinese Access to US Models: Methods and Scale

**Confirmed**: Despite official restrictions, Chinese developers maintain access to US AI models.

**Access Methods**:

- **VPN Usage**: Multiple reports confirm Chinese developers use virtual private networks to access OpenAI services. Seven developers across China told South China Morning Post they use VPNs and third-party services to continue using OpenAI models. [SCMP, July 2024](https://www.scmp.com/tech/tech-trends/article/3269958/openai-blocks-china-developers-scramble-keep-gpt-access-through-vpns)
- **Third-Party Proxies**: Dedicated solutions exist, including GitHub repositories like `openai-proxy`, which is explicitly "a solution provided for Chinese users to address the issue of being unable to make requests to the OpenAI API." [GitHub](https://github.com/unickcheng/openai-proxy)
- **Shadow APIs**: Chinese developers bypass restrictions using reseller services advertised on platforms like Xianyu, offering "low-latency, no-VPN" access to Claude and other models. [SCMP, May 2026](https://www.scmp.com/tech/tech-trends/article/3353002/shadow-apis-how-chinese-developers-bypass-restrictions-access-claude-and-gemini)

**Official Restrictions**: OpenAI explicitly states it "does not operate in Belarus, China, Cuba, Iran, North Korea, Russia, or Venezuela" and that "accessing or offering access to our services outside of the countries and territories listed... may result in your account being blocked or suspended." [OpenAI API Documentation](https://developers.openai.com/api/docs/supported-countries)

### 3. The 30% Claim: What the Data Actually Shows

**Not Directly Verified**: No public source confirms that 30% of OpenAI or Anthropic revenue comes from Chinese accounts.

**What IS Confirmed at 30%+ Levels**:

- **US Companies Using Chinese Models**: Data from OpenRouter shows that since February 8, 2026, **the share of tokens consumed by US companies on Chinese models has held above 30% every week**, reaching 46% in some weeks. This represents a dramatic shift from an 11% average over the preceding 12 months. [BigGo Finance, July 2026](https://finance.biggo.com/news/377d35eb-9305-4af9-b841-517125a46e36)
- **Chinese Models Market Share**: On OpenRouter, Chinese models accounted for **61% of total token consumption** during the week of February 16-22, 2026, surpassing American models for the first time. [Dataconomy, February 2026](https://www.dataconomy.com/2026/02/25/chinese-ai-models-hit-61-market-share-on-openrouter/)
- **OpenAIs Revenue Mix**: Approximately **70% from ChatGPT subscriptions, 25% from API, 5% from Sora and licensing** as of mid-2026. The API segment is where Chinese account usage would be most concentrated. [ValueAddVC, July 2026](https://valueaddvc.com/blog/openai-revenue-2026-20b-arr-4b-month-path-to-profitability)

**Interpretation**: The user's claim likely conflates the direction of the flow. The 30%+ figure is confirmed for **US companies using Chinese models**, not Chinese accounts using US models. However, given that:

- Adversarial distillation from Chinese labs is documented at 16M exchanges
- Chinese developers access US models via proxies
- API revenue is 25% of OpenAIs total

It is plausible that a meaningful (though unverified) percentage of API revenue comes from Chinese-related accounts, but the 30% figure specifically lacks direct sourcing.

### 4. ARR Calculation: MRR x 12 Methodology

**Confirmed**: The practice of calculating ARR as monthly revenue multiplied by 12 is widespread and explicitly documented.

**Industry Standards**:

- **ChartMogul**: "ARR annualizes a companys revenue run rate. In SaaS, this is done by taking your MRR and multiplying it by 12." and "Annualized Run Rate (ARR) = MRR \* 12." [ChartMogul](https://chartmogul.com/saas-metrics/arr/)
- **SaaS Metrics Board**: "Many companies will use Monthly Recurring Revenue (MRR) x 12 to calculate Annual Recurring Revenue." [SaaS Metrics Board](https://www.saasmetricsboard.com/annual-recurring-revenue)
- **Maxio**: "For monthly subscription models, ARR is typically calculated by multiplying MRR by 12." [Maxio](https://www.maxio.com/saaspedia/arr)

**Criticism and Caveats**:

- **Inflation Risk**: This calculation "has been used by transactional businesses that dont sell subscriptions at all" to inflate revenue numbers. [ChartMogul](https://chartmogul.com/saas-metrics/arr/)
- **Growth Distortion**: For rapidly growing companies like OpenAI (270% revenue growth in 2024), annualizing the most recent month significantly overstates the actual annual revenue, as earlier months were much lower.
- **Churn Ignorance**: The MRR x 12 method does not account for customer churn or expansion that would occur over a 12-month period.

**OpenAIs ARR Practice**: OpenAI has reported ARR figures that appear to use this methodology:

- $2B ARR in 2023
- $6B ARR in 2024
- $20B+ ARR in 2025
- $25B ARR by mid-2026

These figures are described as "annualized" rather than recognized GAAP revenue, consistent with the MRR x 12 approach.

### 5. Context: Andrew Hos Bearish Thesis

The user-provided document from Andrew Ho (ex-lab employee) outlines several bearish arguments on frontier lab valuations:

1. **Unprofitability**: Labs are highly unprofitable due to continuous model training costs
2. **Competitive Pressure**: Labs are forced to invest ever-increasing amounts in next-generation models to stay ahead, creating a "profoundly punishing dynamic"
3. **Revenue Assumptions**: A $1T valuation would require $100-200B annual revenue with 80% gross margins, which is unrealistic given training costs
4. **Slower Capability Growth**: Ho believes capability growth will be slower, spikier, and more data-limited than currently assumed
5. **Technological Diffusion**: Integration of LLMs into the economy will take decades due to Hayekian economic calculation problems

**Relevance to This Investigation**: If a significant portion of revenue is from accounts engaged in adversarial distillation (which violates terms of service), and if ARR is inflated by MRR x 12 calculation, then Hos bearish thesis gains additional support from revenue quality concerns.


## Source Notes

### High-Quality Sources


| Source                       | Type              | Reliability | Key Contribution                                  |
| ---------------------------- | ----------------- | ----------- | ------------------------------------------------- |
| DecodeTheFuture (April 2026) | Industry Analysis | High        | 16M adversarial distillation exchanges documented |
| Bloomberg (April 2026)       | Journalism        | High        | Frontier Model Forum cooperation confirmed        |
| OpenAI API Documentation     | Official          | High        | Geographic restrictions confirmed                 |
| SCMP (July 2024, May 2026)   | Journalism        | High        | VPN and shadow API access methods                 |
| ChartMogul                   | Industry Standard | High        | ARR calculation methodology                       |
| OpenRouter Data              | Market Data       | Medium-High | Token share percentages                           |


### Medium-Quality Sources


| Source        | Type           | Reliability | Key Contribution                            |
| ------------- | -------------- | ----------- | ------------------------------------------- |
| BigGo Finance | Financial News | Medium      | 30%+ US token consumption on Chinese models |
| Dataconomy    | Industry News  | Medium      | 61% Chinese model share on OpenRouter       |
| ValueAddVC    | Analysis       | Medium      | OpenAI revenue mix breakdown                |


### Caveats

- OpenAI does not disclose revenue by country, making geographic breakdowns estimates
- Adversarial distillation traffic is detected but may include false positives
- ARR figures are often "annualized" rather than GAAP-recognized revenue


## Open Questions

1. **Exact Revenue Percentage**: What is the actual percentage of OpenAI/Anthropic revenue from Chinese accounts? This would require internal company data or a comprehensive third-party audit.
2. **Distillation Revenue Impact**: What portion of the detected 16M adversarial distillation exchanges resulted in actual paid API usage versus free tier exploitation?
3. **ARR vs. GAAP Revenue**: What is the difference between OpenAIs reported ARR ($25B) and its actual GAAP-recognized revenue for 2026?
4. **Detection Evasion**: How much adversarial distillation activity evades detection through sophisticated IP rotation and account creation strategies?
5. **Revenue At Risk**: If all Chinese-related accounts were blocked tomorrow, what percentage of API revenue would be affected?

## Recommendations

### For Investors and Analysts

1. **Scrutinize ARR Calculations**: When evaluating AI lab valuations, demand clarity on whether ARR is calculated as MRR x 12 or represents actual contracted annual recurring revenue. The difference can be material for high-growth companies.
2. **Assess Revenue Quality**: Inquire about the percentage of revenue from:
  - Direct enterprise contracts (highest quality)
  - API usage from identified customers
  - API usage from anonymous or proxy accounts
  - Geographic breakdown (especially restricted regions)
3. **Monitor Distillation Defense Costs**: Track the increasing spend on detection and prevention of adversarial distillation, as this represents a tax on US labs that Chinese competitors do not pay.
4. **Watch for Regulatory Action**: US government proposals for an AI Information Sharing and Analysis Center (ISAC) could formalize distillation defense efforts, potentially increasing costs further.

### For AI Lab Executives

1. **Improve Revenue Transparency**: Provide more detailed breakdowns of revenue by customer type, geography, and use case to address investor concerns about revenue quality.
2. **Enhance Detection Capabilities**: Continue investing in adversarial distillation detection, but balance this with the risk of false positives that could alienate legitimate enterprise customers.
3. **Consider Pricing Strategy**: The 14x price gap between US and Chinese models is unsustainable if distillation allows Chinese labs to undercut on capability. Consider more aggressive pricing or tiered models.
4. **Diversify Revenue Streams**: Reduce dependence on API revenue that is vulnerable to distillation and geographic arbitrage by expanding enterprise and agent-based offerings.

### For Policymakers

1. **Clarify IP Protections**: Determine whether adversarial distillation constitutes IP theft and what legal frameworks apply.
2. **Address the Economic Asymmetry**: Consider whether policy should address the structural disadvantage faced by US labs that invest in safety and training while competitors can distill capabilities cheaply.
3. **International Coordination**: Work with allied nations to establish consistent rules around model access and usage to prevent regulatory arbitrage.

## Conclusion

The investigation finds that while the specific claim of "30% of AI lab revenue from Chinese distillation accounts" lacks direct public verification, the underlying phenomena are real and material:

- Adversarial distillation by Chinese labs is happening at documented, massive scale (16M exchanges)
- Chinese developers access US models through VPNs and proxies despite restrictions
- ARR calculation as MRR x 12 is standard practice but can inflate revenue figures
- US companies are shifting token consumption to Chinese models at &gt;30% rates

The combination of these factors creates credible risk to AI lab revenue quality and sustainability, supporting bearish valuation perspectives like Andrew Hos. However, the precise 30% revenue figure should be treated as an estimate requiring further verification rather than a confirmed fact.

**Bottom Line**: The music may indeed stop for some participants when distillation defenses tighten or geographic access is more rigorously enforced, creating revenue exposure that warrants further analysis.

---

# Perplexity Response:

## Overview

The claim under investigation has two distinct components: first, that China-linked actors are systematically distilling OpenAI and Anthropic's frontier models, and second, that roughly 30% of OpenAI's and Anthropic's reported "ARR" revenue is actually generated by these same Chinese accounts. The first component is well-documented and confirmed directly by both labs and the U.S. government. The second — the specific 30% revenue-share figure — has no verifiable public source and should be treated as an unsubstantiated inference rather than a disclosed fact.

## The Distillation Problem Is Real and Escalating

Anthropic published a detailed disclosure in February 2026 naming DeepSeek, Moonshot AI, and MiniMax as having run "industrial-scale" distillation campaigns against Claude, using roughly 24,000 fraudulent accounts to generate more than 16 million exchanges designed to extract reasoning, tool-use, and coding capabilities. The scale varied enormously by lab: DeepSeek generated about 150,000 targeted exchanges focused on reasoning chains and censorship-safe outputs, Moonshot AI generated roughly 3.4 million exchanges, and MiniMax accounted for the bulk at over 13 million exchanges, concentrated on agentic coding and orchestration. Notably, when Anthropic shipped a new Claude model mid-campaign, MiniMax redirected nearly half of its traffic within 24 hours to extract capabilities from the updated system — evidence Anthropic says gave it unprecedented visibility into a live distillation operation.[1][2][3][4][5][6][7]

OpenAI made parallel disclosures in a February 2026 memo to the U.S. House Select Committee on China, stating that "the majority of adversarial distillation activity" it observes on its platform "appears to originate from China, and occasionally from Russia". The memo details DeepSeek employees using obfuscated third-party routers, programmatic scraping tools, and networks of unauthorized resellers to circumvent access restrictions. The White House separately warned that foreign entities "principally based in China" were running deliberate, industrial-scale distillation campaigns using tens of thousands of proxy accounts, though China's embassy has publicly called the allegations baseless.[8][9][10][11][12]

## How the Gray Market Actually Works

Independent of the labs' own disclosures, a June 2026 investigation by Oxford China Policy Lab researcher Zilan Qian (published via ChinaTalk) mapped a sprawling Chinese gray-market economy of API proxy services known as "transfer stations" (中转站). These services let Chinese users access Claude and other frontier models without a VPN, foreign credit card, or even an Anthropic account — payment is made in RMB via WeChat or Alipay, and access is resold at roughly 10% of the official price. Operators monetize in three overlapping ways: markup on access, model substitution (quietly routing "flagship" requests to cheaper, lower-accuracy models while still charging premium rates), and — the most consequential piece for the distillation thesis — large-scale harvesting of prompts, responses, and full reasoning chains, which feed directly into supervised fine-tuning and distillation datasets, some of which have surfaced on HuggingFace.[13][12]

This structure matters for interpreting the user's revenue-quality concern: because "transfer station" traffic frequently uses bulk-registered accounts, subdivided Max-plan subscriptions ("APImaxxing"), stolen-card signups, or farmed free credits, a meaningful share of what appears in usage logs as legitimate paid consumption may not represent durable, collectible, or even authorized revenue for the labs.[13]

## The 30% Revenue-Share Figure Is Unsubstantiated

No source identified in this investigation — including Anthropic's own disclosure, OpenAI's congressional memo, White House statements, the ChinaTalk/Oxford investigation, or subsequent financial press coverage — quantifies Chinese distillation-linked accounts as a specific share of either company's revenue, let alone 30%. The 16-million-exchange and 24,000-account figures Anthropic disclosed are usage/volume metrics, not revenue attributions, and Anthropic explicitly frames the accounts as "fraudulent," a categorization that implies non-recoverable or terms-of-service-violating access rather than straightforwardly booked recurring revenue. The claim appears to conflate two separate and only loosely correlated phenomena: the scale of distillation-driven usage volume, and the share of disclosed revenue that volume represents. Absent provider billing data segmented by account provenance, fraud/chargeback adjustments, and paid-versus-discounted account mix, the 30% figure functions as an untested hypothesis rather than a disclosed or inferable fact.[11][1][13]

## The ARR Accounting Critique Is Independently Valid

Separate from the distillation-revenue conflation, the user's underlying skepticism about how "ARR" is calculated is well-founded and independently confirmed by financial reporting. Both OpenAI's and Anthropic's widely cited "annualized run-rate" (ARR) figures are not audited annual recurring revenue in the SaaS-industry sense; they are a single recent month's revenue multiplied by 12. OpenAI's run rate reportedly hit roughly $24-25 billion by early-to-mid 2026, built from approximately $2 billion in monthly revenue, while a June 2026 Financial Times leak of audited financials showed OpenAI's actual booked 2025 revenue was just $13.07 billion against a $20.9 billion operating loss. Anthropic's run rate is reported to have expanded extraordinarily fast — from roughly $9 billion at the end of 2025 to $30 billion by April 2026, $47 billion by May, and figures as high as $69-74 billion by July 2026, according to various trackers.[14][15][16]

| Metric | OpenAI | Anthropic |
|---|---|---|
| ARR, Dec 2025 | ~$21.4B[14] | ~$9B[14] |
| ARR, Apr 2026 | ~$24-25B[17] | ~$30B[18][17] |
| ARR, Jul 2026 (tracker estimates) | ~$41.3B[15] | ~$69-74B[14][15] |
| 2025 audited/booked revenue | $13.07B (leaked FT figure)[14] | Not publicly disclosed as audited |

Analysts have also flagged that the two companies' run-rate figures are not apples-to-apples: OpenAI's chief revenue officer has argued Anthropic's headline number is inflated by roughly $8 billion due to gross-versus-net treatment of cloud-marketplace revenue, and OfficeChai-style analyses note that OpenAI books some Azure-channel sales net while Anthropic books certain cloud-marketplace revenue gross. This accounting noise is a documented, real phenomenon — but it is a separate issue from Chinese distillation activity, and neither disclosed leak nor analyst critique attributes a China-distillation percentage to either firm's run-rate growth.[17]

## Investment Risk Framework, Even Without the 30% Number

Even though the specific 30% figure cannot be verified, the underlying risk thesis deserves serious diligence given the confirmed scale of distillation activity. Several distinct risk vectors are worth separating:

- Revenue-quality risk: gray-market or fraudulent-account usage may not be sticky, compliant, or fully collectible at normal margins, and enforcement crackdowns could suddenly remove it from reported run-rate.[13]
- Cost-leakage risk: distillation traffic consumes expensive inference capacity from the labs while simultaneously enabling Chinese competitors to train cheaper open-weight substitutes, which can compress future US API pricing power.[4][13]
- Policy/enforcement risk: tightening KYC, payment-rail controls, proxy/router bans, and inter-lab intelligence sharing could reduce currently reported "demand" that is in fact gray-market or extraction traffic.[1][13]
- Competitive risk: distilled or homegrown Chinese models (DeepSeek, Moonshot's Kimi, MiniMax, Qwen, Z.ai/GLM) can compress mid-market pricing for coding and agentic use cases, the very use cases identified as most heavily targeted for extraction.[19][4]
- Accounting/optics risk: because run-rate figures are single-month annualizations rather than audited ARR, any temporary spike from promotional, fraudulent, or non-recurring usage — regardless of geography — can overstate durable growth in a headline number markets are pricing off of.[14]

## What Would Be Needed to Verify the 30% Claim

Confirming or refuting a specific revenue-share number would require data neither company currently discloses publicly: billing data segmented by account provenance and geography, reseller/proxy-router attribution, fraud and chargeback adjustments, token-volume analysis specific to accounts flagged as distillation clusters, and a breakdown of paid-versus-discounted or credit-funded account mix. Anthropic's and OpenAI's public disclosures stop at usage-volume and account-count metrics precisely because attributing dollar revenue to adversarial accounts is both more sensitive and more difficult to verify than counting fraudulent sign-ups or flagged API calls. Until a lab, an auditor, or a credible leak produces that breakdown, the 30% figure should be treated as a plausible-sounding hypothesis about a real underlying risk, not a quantified finding.[11][1]
