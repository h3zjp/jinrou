import { observable, action, computed } from 'mobx';
import { Prize, PrizeUtil, NowPrize, NowPrizeType } from './defs';
import { splitPrizesIntoGroups } from './logic/prize-groups';

/**
 * States of prize page.
 * @package
 */
export class PrizeStore {
  constructor(public prizeUtil: PrizeUtil) {}
  /**
   * List of available prizes.
   */
  @observable
  public prizes: Prize[] = [];
  /**
   * Number of available prizes.
   */
  @computed
  public get prizeNumber(): number {
    return this.prizes.length;
  }
  /**
   * Prizes split into groups based on phonetics.
   */
  @computed
  public get prizeGroups(): Prize[][] {
    return splitPrizesIntoGroups(this.prizes);
  }
  /**
   * Map from prize id to display name of prize.
   */
  @computed
  public get prizeDisplayMap(): Map<string, string> {
    const result = new Map();
    for (const { id, name } of this.prizes) {
      result.set(id, name);
    }
    return result;
  }
  /**
   * Currently set prize of user.
   */
  @observable
  public nowprize: NowPrize[] = [];
  /**
   * Current template of prize setting.
   */
  @computed
  public get prizeTemplate(): Array<NowPrizeType> {
    return this.prizeUtil.getPrizesComposition(this.prizeNumber);
  }

  /**
   * Whether list of prizes are shrinked.
   */
  @observable
  public shrinked: boolean = true;

  /**
   * Set available prizes
   */
  @action
  public setPrizes(prizes: Prize[]): void {
    this.prizes = prizes;
  }
  /**
   * Set current prizes
   */
  @action
  public setNowPrize(nowprize: NowPrize[]): void {
    this.nowprize = nowprize;
  }
  /**
   * Set shrinkedness of prize list
   */
  @action
  public setShrinked(shrinked: boolean): void {
    this.shrinked = shrinked;
  }
}
